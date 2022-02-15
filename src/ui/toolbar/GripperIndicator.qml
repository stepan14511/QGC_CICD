/****************************************************************************
 *
 * (c) 2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Gripper Indicator
Item {
    id:             _root
    width:          (gripperValuesColumn.x + gripperValuesColumn.width) * 1.1
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true
    property var _lastCommand: 0

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property var _vehicles: QGroundControl.multiVehicleManager.vehicles

    function getGripperStatusString() {
        var gripperStatusString = "?"

        if (_lastCommand == 0) {
            gripperStatusString = "Unknown"
        } else if (_lastCommand == 1) {
            gripperStatusString = "Released"
        } else if (_lastCommand == 2) {
            gripperStatusString = "Grabbed"
        }

        // var vehicle_idx;
        // for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
        //     gripperStatusString = "unknown"
        //     break
        // }

        return gripperStatusString
    }

    function getGlobalStatusString() {
        var globalStatusString = ""
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            globalStatusString = "Unknown"
            break
        }
        return globalStatusString
    }

    function isActive() {
        var status = false
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            status = true
            break
        }
        return status
    }

    function setGripperCmd(cmd) {
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            _vehicles.get(vehicle_idx).gripperChangeState(cmd)
        }

        // if(cmd == 1){
        //     mainWindow.releaseGripperRequest()
        // }else if(cmd == 2){
        //     mainWindow.grabGripperRequest()
        // }

        _lastCommand = cmd
    }

    Component {
        id: gripperInfo

        Rectangle {
            width:  gripperCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: gripperCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 gripperCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(gripperPanelLabel.width, gripperIdGrid.width, gripperGrid.width, gripperReleaseGrabGrid.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             gripperPanelLabel
                    text:           (_activeVehicle) ? qsTr("Gripper user panel") : qsTr("Gripper unavalible")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 gripperIdGrid
                    visible:            (_activeVehicle)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    QGCLabel { text: qsTr("Hardpoint id:") }
                    QGCLabel { text: qsTr("1") }
                }

                GridLayout {
                    id:                 gripperGrid
                    visible:            (_activeVehicle)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    QGCLabel { text: qsTr("Status estimation:") }
                    QGCLabel { text: _activeVehicle ? getGripperStatusString() : qsTr("N/A", "No data to display") }
                }

                GridLayout {
                    id:                 gripperReleaseGrabGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            true
                        text:               qsTr("Release")
                        enabled:            true
                        onClicked: {
                            // mainWindow.hideIndicatorPopup()
                            setGripperCmd(1)
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            true
                        text:               qsTr("Grab")
                        enabled:            true
                        onClicked: {
                            // mainWindow.hideIndicatorPopup()
                            setGripperCmd(2)
                        }
                    }
                }
            }
        }
    }

    QGCColoredImage {
        id:                 gripperIcon
        width:              height
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        source:             _lastCommand == 1 ? "/qmlimages/GripperReleased.svg" : "/qmlimages/GripperGrabbed.svg"
        fillMode:           Image.PreserveAspectFit
        sourceSize.height:  height
        opacity:            1
        color:              (isActive()) ? qgcPal.colorBlue : qgcPal.colorGrey
    }

    Column {
        id:                     gripperValuesColumn
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth / 2
        anchors.left:           gripperIcon.right

        QGCLabel {
            id:             globalStatusLabel
            text:           getGlobalStatusString()
            font.family:    ScreenTools.demiboldFontFamily
            anchors.horizontalCenter: parent.horizontalCenter
            visible:        false
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, gripperInfo)
        }
    }
}
