/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Controllers
import QGroundControl.ScreenTools
import QGroundControl.Palette

Item {
    id:             rootItem
    anchors.fill:   parent

    property var screenX
    property var screenY
    property var screenXrateInitCoocked
    property var screenYrateInitCoocked

    property var  isUDP:                        QGroundControl.settingsManager.payloadSettings.type.rawValue === 0
     
    property var  siyiCameraInterface:          QGroundControl.multiVehicleManager.siyiCameraInterface
    property var  activeVehicle:                QGroundControl.multiVehicleManager.activeVehicle
    property var  gimbalController_mavlink:     activeVehicle ? activeVehicle.gimbalController : undefined
    property var  gimbalController:             isUDP ? siyiCameraInterface : gimbalController_mavlink
    property var  activeGimbal:                 gimbalController_mavlink ? gimbalController_mavlink.activeGimbal : undefined
    property bool gimbalAvailable:              activeGimbal != undefined
    property var  gimbalControllerSettings:     QGroundControl.settingsManager.gimbalControllerSettings
    property bool cameraTrackingEnabled:        false // Used to ignore clicks when camera tracking operation is active, otherwise it would collide with these gimbal controls
    property bool shouldProcessClicks:          gimbalControllerSettings.EnableOnScreenControl.value && ((activeGimbal && !cameraTrackingEnabled) || isUDP) ? true : false

    function clickControl() {
        if (!shouldProcessClicks) {
            return
        }
        // If click and slide control, return, it uses press and release
        if (!gimbalControllerSettings.ControlType.rawValue == 0) {
            return
        }
        clickAndPoint(x, y)
    }

    // Sends a +-(0-1) xy value to vehicle.gimbalController.gimbalOnScreenControl
    function clickAndPoint() {
        if (rootItem.gimbalAvailable) {
            var xCoocked =  ( (screenX / parent.width)  * 2) - 1
            var yCoocked = -( (screenY / parent.height) * 2) + 1
            // console.log("X global: " + x + " Y global: " + y)
            // console.log("X coocked: " + xCoocked + " Y coocked: " + yCoocked)
            gimbalController.gimbalOnScreenControl(xCoocked, yCoocked, true, false, false)
        } else {
            // We should never be here
            console.log("gimbal not available")
        }
    }

    function pressControl() {
        if (!shouldProcessClicks) {
            return
        }
        // If click and point control return, that is handled exclusively on clickAndPoint()
        if (!gimbalControllerSettings.ControlType.rawValue == 1) {
            return
        }
        sendRateTimer.start()
        screenXrateInitCoocked =  ( ( screenX / parent.width)  * 2) - 1
        screenYrateInitCoocked = -( ( screenY / parent.height) * 2) + 1
    }

    function releaseControl() {
        if (!shouldProcessClicks) {
            return
        }
        // If click and point control return, that is handled exclusively on clickAndPoint()
        if (!gimbalControllerSettings.ControlType.rawValue == 1) {
            return
        }
        sendRateTimer.stop()
        gimbalController.gimbalOnScreenControl(0, 0, false, true, true)
        screenXrateInitCoocked = null
        screenYrateInitCoocked = null
    }

    Timer {
        id:             sendRateTimer
        interval:       100
        repeat:         true
        onTriggered: {
            if (rootItem.gimbalAvailable || isUDP) {
                var xCoocked =  ( ( screenX / parent.width)  * 2) - 1
                var yCoocked = -( ( screenY / parent.height) * 2) + 1
                xCoocked -= screenXrateInitCoocked
                yCoocked -= screenYrateInitCoocked
                gimbalController.gimbalOnScreenControl(xCoocked, yCoocked, false, true, true)
            } else {
                console.log("gimbal not available")
            }
        }
    }
}