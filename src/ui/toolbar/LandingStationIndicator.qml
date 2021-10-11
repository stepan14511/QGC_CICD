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
    property int actuator_mode_auto: 0
    property int actuator_mode_manual: 1
    property int actuator_mode_force_manual: 2
    property int actuatorsMode: 0

    property int landing_station_stage_open: 1
    property int landing_station_stage_close: 2

    property int gate_stage_unknown: 0
    property int gate_stage_waiting: 1
    property int gate_stage_open: 2
    property int gate_stage_close: 3

    property int elevator_stage_unknown: 0
    property int elevator_stage_waiting: 1
    property int elevator_stage_up: 2
    property int elevator_stage_down: 3

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property var _vehicles: QGroundControl.multiVehicleManager.vehicles

    function getCoverStatusString() {
        var coverStatusString = "-"
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if(coverStatusValue == gate_stage_waiting) {
                coverStatusString = "waiting"
            }else if(coverStatusValue == gate_stage_open) {
                coverStatusString = "open"
            }else if(coverStatusValue == gate_stage_close) {
                coverStatusString = "closed"
            }else if(coverStatusValue == 4) {
                coverStatusString = "opening"
            }else if(coverStatusValue == 5) {
                coverStatusString = "closing"
            }else if(coverStatusValue == gate_stage_unknown) {
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
            if(elevatorStatusValue == elevator_stage_waiting) {
                elevatorStatusString = "waiting"
            }else if(elevatorStatusValue == elevator_stage_up) {
                elevatorStatusString = "lifted"
            }else if(elevatorStatusValue == elevator_stage_down) {
                elevatorStatusString = "down"
            }else if(elevatorStatusValue == 4) {
                elevatorStatusString = "is lifting"
            }else if(elevatorStatusValue == 5) {
                elevatorStatusString = "is going down"
            }else if(elevatorStatusValue == elevator_stage_unknown) {
                elevatorStatusString = "unknown"
            }
        }
        return elevatorStatusString
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
            }else if(elevatorStatusValue == elevator_stage_down && coverStatusValue == gate_stage_close) {
                globalStatusString = "Closed"
            }else if(elevatorStatusValue == elevator_stage_up && coverStatusValue == gate_stage_open) {
                globalStatusString = "Open"
            }else if(elevatorStatusValue == elevator_stage_down && coverStatusValue == gate_stage_open) {
                globalStatusString = "intermediate"
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

    function getLandingStationOpenEnableStatus() {
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            if(coverStatusValue == gate_stage_close &&
               elevatorStatusValue == elevator_stage_down) {
                return true
            }
        }
        return false
    }
    function getLandingStationCloseEnableStatus() {
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            if(coverStatusValue == gate_stage_open &&
               elevatorStatusValue == elevator_stage_up) {
                return true
            }
        }
        return false
    }
    function getCoverOpenEnableStatus() {
        if(actuatorsMode == actuator_mode_force_manual) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if(coverStatusValue == gate_stage_close || coverStatusValue == gate_stage_waiting) {
                return true
            }
        }
        return false
    }
    function getCoverCloseEnableStatus() {
        if(actuatorsMode == actuator_mode_force_manual) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if((elevatorStatusValue == elevator_stage_down || elevatorStatusValue == elevator_stage_waiting) &&
               (coverStatusValue == gate_stage_open || coverStatusValue == gate_stage_waiting)) {
                return true
            }
        }
        return false
    }
    function getElevatorLiftEnableStatus() {
        if(actuatorsMode == actuator_mode_force_manual) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            var coverStatusValue = _vehicles.get(vehicle_idx).landingStation.coverStatus.value
            if((coverStatusValue == gate_stage_open || coverStatusValue == gate_stage_waiting) &&
               (elevatorStatusValue == elevator_stage_down || elevatorStatusValue == elevator_stage_waiting)) {
                return true
            }
        }
        return false
    }
    function getElevatorDownEnableStatus() {
        if(actuatorsMode == actuator_mode_force_manual) {
            return true
        }
        var vehicle_idx;
        for (vehicle_idx = 0; vehicle_idx < _vehicles.count; vehicle_idx++) {
            var elevatorStatusValue = _vehicles.get(vehicle_idx).landingStation.elevatorStatus.value
            if(elevatorStatusValue == elevator_stage_up || elevatorStatusValue == elevator_stage_waiting) {
                return true
            }
        }
        return false
    }

    function setLandingStationCmd(cmd) {
        if(cmd == 0){
            mainWindow.holdLandingStationRequest()
        }else if(cmd == 1){
            mainWindow.openLandingStationRequest()
        }else if(cmd == 2){
            mainWindow.closeLandingStationRequest()
        }
    }

    function setCoverCmd(cmd) {
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

                    QGCLabel { text: qsTr("Actuators mode:") }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        text:               actuatorsMode == actuator_mode_auto ? qsTr("auto") : (actuatorsMode == actuator_mode_manual ? qsTr("manual") : qsTr("force manual"))
                        heightFactor:       0.1
                        showBorder:         true
                        onClicked: {
                            actuatorsMode = (actuatorsMode < actuator_mode_force_manual) ? actuatorsMode + 1 : 0
                        }
                    }
                    QGCLabel { text: qsTr("1. Cover:") }
                    QGCLabel { text: _activeVehicle ? getCoverStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("2. Elevator:") }
                    QGCLabel { text: _activeVehicle ? getElevatorStatusString() : qsTr("N/A", "No data to display") }
                    QGCLabel { text: qsTr("3. Charging:") }
                    QGCLabel { text: _activeVehicle ? getChargingStatusString() : qsTr("--.--", "No data to display") }
                    QGCLabel { text: qsTr("4. Drone:") }
                    QGCLabel { text: _activeVehicle ? getDroneStatusString() : qsTr("N/A", "No data to display") }
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
                        visible:            false
                        text:               qsTr("start")
                        enabled:            false
                        onClicked: {
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            false
                        text:               qsTr("soft stop")
                        enabled:            false
                        onClicked: {
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            false
                        text:               qsTr("hard stop")
                        enabled:            false
                        onClicked: {
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }

                QGCLabel {
                    id:             landingStationChargingControlFeaturesLabel
                    text:           qsTr("Charging control features:")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
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
                    id:             landingStationActuatorsControlFeaturesLabel
                    text:           qsTr("Actuators control features:")
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
                        visible:            actuatorsMode != actuator_mode_auto
                        text:               qsTr("hold gate")
                        onClicked: {
                            setCoverCmd(0)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode != actuator_mode_auto
                        text:               qsTr("open gate")
                        enabled:            getCoverOpenEnableStatus()
                        onClicked: {
                            setCoverCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode != actuator_mode_auto
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
                        visible:            actuatorsMode != actuator_mode_auto
                        text:               qsTr("hold elevator")
                        onClicked: {
                            setElevatorCmd(0)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode != actuator_mode_auto
                        text:               qsTr("lift elevator")
                        enabled:            getElevatorLiftEnableStatus()
                        onClicked: {
                            setElevatorCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode != actuator_mode_auto
                        text:               qsTr("down elevator")
                        enabled:            getElevatorDownEnableStatus()
                        onClicked: {
                            setElevatorCmd(2)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }

                GridLayout {
                    id:                 landingStationControlGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3

                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode == actuator_mode_auto
                        text:               qsTr("stop")
                        onClicked: {
                            setLandingStationCmd(0)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode == actuator_mode_auto
                        text:               qsTr("open")
                        enabled:            getLandingStationOpenEnableStatus()
                        onClicked: {
                            setLandingStationCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            actuatorsMode == actuator_mode_auto
                        text:               qsTr("close")
                        enabled:            getLandingStationCloseEnableStatus()
                        onClicked: {
                            setLandingStationCmd(2)
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
                        visible:            false
                        text:               qsTr("grab drone")
                        onClicked: {
                            setCenteringMechanismCmd(1)
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                    QGCButton {
                        Layout.alignment:   Qt.AlignHCenter
                        visible:            false
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
