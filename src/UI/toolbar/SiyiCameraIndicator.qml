/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.FactSystem
import QGroundControl.FactControls
import QGroundControl.Controls
import QGroundControl.ScreenTools

Item {
    id:     cameraRoot
    width:  size
    height: size

    property real size:     _isCamera ? 40 : 0
    property real percent:  0

    property var    _multiVehicleManager:       QGroundControl.multiVehicleManager
    property var    _activeVehicle:             _multiVehicleManager.activeVehicle
    property var    _settingsManager:           QGroundControl.settingsManager
    property var    _appSettings:               _settingsManager.appSettings
    property var    _payloadSettings:           _settingsManager.payloadSettings
    property bool   _isCamera:                  _payloadSettings.type.rawValue === 0

    function getColor() {
        var isCameraConnected = _payloadSettings.isCameraResponding.rawValue
        if (isCameraConnected){
            return Qt.rgba(0,1,0,1)
        } else{
            return Qt.rgba(1,0,0,1)
        }
    }

    QGCColoredImage {
        source:             "/InstrumentValueIcons/camera.svg"
        fillMode:           Image.PreserveAspectFit
        anchors.fill:       parent
        color:              getColor()
        sourceSize.height:  size
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(siyiCameraPage, cameraRoot)
    }

    Component {
        id: siyiCameraPage
        SiyiCameraPage { }
    }
}