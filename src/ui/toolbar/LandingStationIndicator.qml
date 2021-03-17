/****************************************************************************
 *
 * (c) 2021 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
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
//-- LandingStation Indicator
Item {
    id:             _root
    width:          (landingStationValuesColumn.x + landingStationValuesColumn.width) * 1.1
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function getCoverStatusString() {
        var coverStatusValue = _activeVehicle.landingStation.coverStatus.value
        var coverStatusString = "unknown"
        if(coverStatusValue == 1) {
            coverStatusString = "open"
        }else if(coverStatusValue == 2) {
            coverStatusString = "closed"
        }else if(coverStatusValue == 3) {
            coverStatusString = "opening"
        }else if(coverStatusValue == 4) {
            coverStatusString = "closing"
        }
        return coverStatusString
    }

    function getDroneStatusString() {
        var droneStatusValue = _activeVehicle.landingStation.droneStatus.value
        var droneStatusString = "unknown"
        if(droneStatusValue == 1) {
            droneStatusString = "inside"
        }else if(droneStatusValue == 2) {
            droneStatusString = "outside"
        }
        return droneStatusString
    }

    function getChargingStatusString() {
        var chargingStatusValue = _activeVehicle.landingStation.chargingStatus.value
        var chargingStatusString = "unknown"
        if(chargingStatusValue == 1) {
            chargingStatusString = "calibrating"
        }else if(chargingStatusValue == 2) {
            chargingStatusString = "waiting"
        }else if(chargingStatusValue == 3) {
            chargingStatusString = "charging"
        }else if(chargingStatusValue == 4) {
            chargingStatusString = "finished"
        }
        return chargingStatusString
    }

    Component {
        id: landingStationInfo

        Rectangle {
            width:  landingStationCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: landingStationCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 landingStationCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(landingStationGrid.width, landingStationCoverControlGrid, landingStationLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             landingStationLabel
                    text:           (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? qsTr("Landing station status") : qsTr("GPS Data Unavailable")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 landingStationGrid
                    visible:            (_activeVehicle)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    QGCLabel { text: qsTr("Mode:") }
                    QGCLabel { text: _activeVehicle ? qsTr("manual") : qsTr("auto") }
                    QGCLabel { text: qsTr("Cover status:") }
                    QGCLabel { text: _activeVehicle ? getCoverStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("Drone status:") }
                    QGCLabel { text: _activeVehicle ? getDroneStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("Charging:") }
                    QGCLabel { text: _activeVehicle ? getChargingStatusString() : qsTr("--.--", "No data to display") }
                }

                GridLayout {
                    id:                 landingStationCoverControlGrid
                    visible:            (_activeVehicle)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("auto")

                        property bool btnPressed: false

                        onPressAndHold: btnPressed = true

                        onClicked: {
                            btnPressed = false
                            mainWindow.hideIndicatorPopup()
                        }
                    }

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("open")

                        property bool btnPressed: false

                        onPressAndHold: btnPressed = true

                        onClicked: {
                            btnPressed = false
                            mainWindow.hideIndicatorPopup()
                        }
                    }

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("close")

                        property bool btnPressed: false

                        onPressAndHold: btnPressed = true

                        onClicked: {
                            btnPressed = false
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }

                
                GridLayout {
                    id:                 landingStationChargingControlGrid
                    visible:            (_activeVehicle)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3

                    property bool autoBtnPressed: true
                    property bool startBtnPressed: false
                    property bool stopBtnPressed: false

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("auto")

                        onClicked: {
                            autoBtnPressed = true
                            startBtnPressed = false
                            stopBtnPressed = false
                            // mainWindow.hideIndicatorPopup()
                        }
                    }

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("charge")

                        onClicked: {
                            autoBtnPressed = false
                            startBtnPressed = true
                            stopBtnPressed = false
                            mainWindow.hideIndicatorPopup()
                        }
                    }

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("stop")

                        onClicked: {
                            autoBtnPressed = false
                            startBtnPressed = false
                            stopBtnPressed = true
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }
                
            }
        }
    }

    QGCColoredImage {
        id:                 landingStationIcon
        width:              height
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        source:             "/qmlimages/LandingStation.svg"
        fillMode:           Image.PreserveAspectFit
        sourceSize.height:  height
        opacity:            (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? 1 : 0.5
        color:              qgcPal.colorBlue
    }

    Column {
        id:                     landingStationValuesColumn
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth / 2
        anchors.left:           landingStationIcon.right

    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, landingStationInfo)
        }
    }
}
