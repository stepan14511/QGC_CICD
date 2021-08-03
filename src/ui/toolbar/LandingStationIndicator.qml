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
    property bool isUnsafeActuatorControlModeActivated: false

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property var _vehicles: QGroundControl.multiVehicleManager.vehicles

    function getLandingStationStatusString() {
        var coverStatusString = "-"
        return coverStatusString
    }

    function getCoverStatusString() {
        var coverStatusString = "-"
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if(coverStatusValue == 1) {
                coverStatusString = "waiting"
            }else if(coverStatusValue == 2) {
                coverStatusString = "open"
            }else if(coverStatusValue == 3) {
                coverStatusString = "closed"
            }else if(coverStatusValue == 4) {
                coverStatusString = "opening"
            }else if(coverStatusValue == 5) {
                coverStatusString = "closing"
            }else if(coverStatusValue == 0) {
                coverStatusString = "unknown"
            }
        }
        return coverStatusString
    }

    function getElevatorStatusString() {
        var elevatorStatusString = "-"
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            if(elevatorStatusValue == 1) {
                elevatorStatusString = "waiting"
            }else if(elevatorStatusValue == 2) {
                elevatorStatusString = "lifted"
            }else if(elevatorStatusValue == 3) {
                elevatorStatusString = "down"
            }else if(elevatorStatusValue == 4) {
                elevatorStatusString = "is lifting"
            }else if(elevatorStatusValue == 5) {
                elevatorStatusString = "is going down"
            }else if(elevatorStatusValue == 0) {
                elevatorStatusString = "unknown"
            }
        }
        return elevatorStatusString
    }

    function getCenteringMechanismStatusString() {
        var centeringMechanismStatusString = "-"
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var centeringMechanismStatusValue = _vehicles.get(vehicle_idx).landingStation.centeringMechanismStatus.value
            if(centeringMechanismStatusValue == 1) {
                centeringMechanismStatusString = "waiting"
            }else if(centeringMechanismStatusValue == 2) {
                centeringMechanismStatusString = "forward"
            }else if(centeringMechanismStatusValue == 3) {
                centeringMechanismStatusString = "backward"
            }else if(centeringMechanismStatusValue == 4) {
                centeringMechanismStatusString = "is going forward"
            }else if(centeringMechanismStatusValue == 5) {
                centeringMechanismStatusString = "is going backward"
            }else if(centeringMechanismStatusValue == 0) {
                centeringMechanismStatusString = "unknown"
            }
        }
        return centeringMechanismStatusString
    }

    function getGlobalStatusString() {
        var globalStatusString = ""
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var connectionStatusValue = _vehicles.get(vehicle_idx).landingStation.connectionStatus.value
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if(connectionStatusValue == 0) {
                globalStatusString = ""
            }else if(elevatorStatusValue == 3 && coverStatusValue == 3) {
                globalStatusString = "Closed"
            }else if(elevatorStatusValue == 2 && coverStatusValue == 2) {
                globalStatusString = "Open"
            }else if(elevatorStatusValue == 3 && coverStatusValue == 2) {
                globalStatusString = "Waiting"
            }else if(elevatorStatusValue >= 2 && coverStatusValue >= 2) {
                globalStatusString = "In process"
            }else{
                globalStatusString = "Unknown"
            }
        }
        return globalStatusString
    }

    function getDroneStatusString() {
        var droneStatusString = "-"
        return droneStatusString
    }

    function getChargingStatusString() {
        var chargingStatusString = "-"
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var chargingStatusValue = _vehicles.get(vehicle_idx).landingStation.chargingStatus.value
            if(chargingStatusValue == 1) {
                chargingStatusString = "waiting"
            }else if(chargingStatusValue == 2) {
                chargingStatusString = "calibrating"
            }else if(chargingStatusValue == 3) {
                chargingStatusString = "charging"
            }else if(chargingStatusValue == 4) {
                chargingStatusString = "finished"
            }else if(chargingStatusValue == 5) {
                chargingStatusString = "paused"
            }else if(chargingStatusValue == 6) {
                chargingStatusString = "saving mode"
            }else if(chargingStatusValue == 7) {
                chargingStatusString = "disabled"
            }else if(chargingStatusValue == 0) {
                chargingStatusString = "unknown"
            }
        }
        return chargingStatusString
    }

    function getCoverOpenEnableStatus() {
        if(isUnsafeActuatorControlModeActivated == true) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if(coverStatusValue == 3 || coverStatusValue == 1) {
                return true
            }
        }
        return false
    }
    function getCoverCloseEnableStatus() {
        if(isUnsafeActuatorControlModeActivated == true) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if((elevatorStatusValue == 3 || elevatorStatusValue == 1) &&
               (coverStatusValue == 2 || coverStatusValue == 1)) {
                return true
            }
        }
        return false
    }
    function getElevatorLiftEnableStatus() {
        if(isUnsafeActuatorControlModeActivated == true) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if((coverStatusValue == 2 || coverStatusValue == 1) &&
               (elevatorStatusValue == 3 || elevatorStatusValue == 1)) {
                return true
            }
        }
        return false

    }
    function getElevatorDownEnableStatus() {
        if(isUnsafeActuatorControlModeActivated == true) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            if(elevatorStatusValue == 2 || elevatorStatusValue == 1) {
                return true
            }
        }
        return false
    }

    function setCoverCmd(cmd) {
        mainWindow.autoLandingStationCoverRequest()
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            _vehicles.get(vehicle_idx).landingStation.coverCmd.value = cmd
        }
        if(cmd == 0){
            mainWindow.autoLandingStationCoverRequest()
        }else if(cmd == 1){
            mainWindow.openLandingStationCoverRequest()
        }else if(cmd == 2){
            mainWindow.closeLandingStationCoverRequest()
        }
    }

    function setElevatorCmd(cmd) {
        if(cmd == 0){
            mainWindow.holdLandingStationElevatorRequest()
        }else if(cmd == 1){
            mainWindow.liftLandingStationElevatorRequest()
        }else if(cmd == 2){
            mainWindow.downLandingStationElevatorRequest()
        }
    }

    function setCenteringMechanismCmd(cmd) {
        if(cmd == 0){
            mainWindow.holdLandingStationCenteringMechanismRequest()
        }else if(cmd == 1){
            mainWindow.forwardLandingStationCenteringMechanismRequest()
        }else if(cmd == 2){
            mainWindow.backwardLandingStationCenteringMechanismRequest()
        }
    }

    function getCoverCmd() {
        var vehicle_idx;
        var cmd = 0
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            if(_vehicles.get(vehicle_idx).landingStation.coverCmd.value != 0){
                cmd = _vehicles.get(vehicle_idx).landingStation.coverCmd.value
            }
        }
        return cmd
    }


    function isActive() {
        var status = false
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var connectionStatusValue = _vehicles.get(vehicle_idx).landingStation.connectionStatus.value
            if(connectionStatusValue != 0) {
                status = true
            }
        }
        return status
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
                width:              Math.max(landingStationGrid.width, landingStationCoverControlGrid.width, landingStationLabel.width, landingStationChargingControlGrid.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             landingStationLabel
                    text:           (_activeVehicle) ? qsTr("Landing station user panel") : qsTr("Landing station unavalible")
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

                    QGCLabel { text: qsTr("Actuators checks:") }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               isUnsafeActuatorControlModeActivated ? qsTr("disabled") : qsTr("enabled")
                        heightFactor:       0.1
                        showBorder:         true
                        onClicked: {
                            isUnsafeActuatorControlModeActivated = !isUnsafeActuatorControlModeActivated
                        }
                    }
                    QGCLabel { text: qsTr("Landing station status:") }
                    QGCLabel { text: _activeVehicle ? getLandingStationStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("1. Cover:") }
                    QGCLabel { text: _activeVehicle ? getCoverStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("2. Elevator:") }
                    QGCLabel { text: _activeVehicle ? getElevatorStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("3. Centering mechanism:") }
                    QGCLabel { text: _activeVehicle ? getCenteringMechanismStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("4. Drone:") }
                    QGCLabel { text: _activeVehicle ? getDroneStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("5. Charging:") }
                    QGCLabel { text: _activeVehicle ? getChargingStatusString() : qsTr("--.--", "No data to display") }
                }

                GridLayout {
                    id:                 landingStationStartStopGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("start")
                        enabled:            false
                        onClicked: {
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("soft stop")
                        enabled:            false
                        onClicked: {
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("hard stop")
                        enabled:            false
                        onClicked: {
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }

                GridLayout {
                    id:                 landingStationChargingControlGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("calibrate")
                        enabled:            false
                        onClicked: {
                            mainWindow.calibrateLandingStationChargingRequest()
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("start charging")
                        onClicked: {
                            mainWindow.autoLandingStationChargingRequest()
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("stop charging")
                        onClicked: {
                            mainWindow.disableLandingStationChargingRequest()
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }

                QGCLabel {
                    id:             landingStationMaintainerLabel
                    text:           qsTr("Actuator control features:")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
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
                        text:               qsTr("hold gate")
                        onClicked: {
                            setCoverCmd(0)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("open gate")
                        enabled:            getCoverOpenEnableStatus()
                        onClicked: {
                            setCoverCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("close gate")
                        enabled:            getCoverCloseEnableStatus()
                        onClicked: {
                            setCoverCmd(2)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }


                GridLayout {
                    id:                 landingStationElevatorControlGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("hold elevator")
                        onClicked: {
                            setElevatorCmd(0)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("lift elevator")
                        enabled:            getElevatorLiftEnableStatus()
                        onClicked: {
                            setElevatorCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("down elevator")
                        enabled:            getElevatorDownEnableStatus()
                        onClicked: {
                            setElevatorCmd(2)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }
                
                GridLayout {
                    id:                 landingStationCenteringMechanismControlGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("grab drone")
                        onClicked: {
                            setCenteringMechanismCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("leave drone")
                        onClicked: {
                            setCenteringMechanismCmd(2)
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
        opacity:            1
        color:              (isActive()) ? qgcPal.colorBlue : qgcPal.colorGrey
    }

    Column {
        id:                     landingStationValuesColumn
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth / 2
        anchors.left:           landingStationIcon.right

        QGCLabel {
            id:             kekLabel
            text:           getGlobalStatusString()
            font.family:    ScreenTools.demiboldFontFamily
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, landingStationInfo)
        }
    }
}
