/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.MultiVehicleManager
import QGroundControl.ScreenTools
import QGroundControl.Palette
import QGroundControl.FactSystem
import QGroundControl.FactControls

ToolIndicatorPage {
    showExpand: true

    property var          rtkSettings:          QGroundControl.settingsManager.rtkSettings

    readonly property int chcnavUnknown:        0
    readonly property int chcnavAA450:          1
    readonly property int chcnavAA10:           2
    property var      chcnavLidarType:          chcnavUnknown

    readonly property int cmdCreateProject:     1
    readonly property int cmdStartCapturing:    2
    readonly property int cmdStopCapturing:     3
    readonly property int cmdCloseProject:      4
    readonly property int cmdTestPhoto:         5


    readonly property int statusUnknown:        65535
    readonly property int statusInit:           0
    readonly property int statusOpening1:       257
    readonly property int statusOpening2:       5121
    readonly property int statusOpen:           5120
    readonly property int statusCapturing:      512
    readonly property int statusStopping1:      769
    readonly property int statusStopping2:      5377
    readonly property int statusStopped:        5376
    readonly property int statusClosed:         5632

    function getPanelName() {
        var lidarPanelName = "-"
        if(chcnavLidarType == chcnavAA450)          { lidarPanelName = "CHCNAV Alpha Air 450 Panel" }
        else if(chcnavLidarType == chcnavAA10)      { lidarPanelName = "CHCNAV Alpha Air 10 Panel" }
        else                                        { lidarPanelName = "CHCNAV Lidar Panel" }

        return lidarPanelName
    }

    function getLidarStatusString() {
        var lidarStatusString = "-"
        var status_code = _activeVehicle.chcnavAA450.status.value

        if(status_code == 1)                        { lidarStatusString = "WAIT_FOR_INIT" }
        else if(status_code == statusInit)          { lidarStatusString = "INITED" }
        else if(status_code == statusOpening1)      { lidarStatusString = "WAIT_FOR_OPENING 1/2" }
        else if(status_code == statusOpening2)      { lidarStatusString = "WAIT_FOR_OPENING 2/2" }
        else if(status_code == statusOpen)          { lidarStatusString = "OPEN" }
        else if(status_code == 513)                 { lidarStatusString = "WAIT_FOR_CAPTURING" }
        else if(status_code == statusCapturing)     { lidarStatusString = "CAPTURING" }
        else if(status_code == statusStopping1)     { lidarStatusString = "WAIT_FOR_STOPPING 1/2" }
        else if(status_code == statusStopping2)     { lidarStatusString = "WAIT_FOR_STOPPING 2/2" }
        else if(status_code == statusStopped)       { lidarStatusString = "STOPPED" }
        else if(status_code == 1025)                { lidarStatusString = "WAIT_FOR_CLOSING" }
        else if(status_code == statusClosed)        { lidarStatusString = "CLOSED" }
        else                                        { lidarStatusString = "Unknown"}

        return lidarStatusString
    }

    function getStatusHint() {
        var lidarStatusString = "-"
        var status_code = _activeVehicle.chcnavAA450.status.value

        if(status_code == 1)                        { lidarStatusString = "It takes ~40 seconds..." }
        else if(status_code == statusInit)          { lidarStatusString = "The lidar has been initialized." }
        else if(status_code == statusOpening1)      { lidarStatusString = "It takes ~3 minutes..." }
        else if(status_code == statusOpening2)      { lidarStatusString = "It takes ~3 minutes..." }
        else if(status_code == statusOpen)          { lidarStatusString = "The project has been opened." }
        else if(status_code == 513)                 { lidarStatusString = "It takes a few seconds..." }
        else if(status_code == statusCapturing)     { lidarStatusString = "The lidar is capturing." }
        else if(status_code == statusStopping1)     { lidarStatusString = "It takes ~3 minutes..." }
        else if(status_code == statusStopping2)     { lidarStatusString = "It takes ~3 minutes..." }
        else if(status_code == statusStopped)       { lidarStatusString = "The capturing has been stopped." }
        else if(status_code == 1025)                { lidarStatusString = "It takes a few seconds..." }
        else if(status_code == statusClosed)        { lidarStatusString = "The project has been closed." }
        else                                        { lidarStatusString = "Device is offline"}

        return lidarStatusString
    }

    function isCreateCommandEnabled() {
        var status_code = _activeVehicle.chcnavAA450.status.value
        return status_code == statusInit || status_code == statusClosed || status_code == statusUnknown
    }

    function isStartCapturingCommandEnabled() {
        var status_code = _activeVehicle.chcnavAA450.status.value
        return status_code == statusOpen || status_code == statusOpening2 || status_code == statusStopped || status_code == statusUnknown
    }

    function isStopCapturingCommandEnabled() {
        var status_code = _activeVehicle.chcnavAA450.status.value
        return status_code == statusCapturing || status_code == statusUnknown
    }

    function isCloseProjectCommandEnabled() {
        var status_code = _activeVehicle.chcnavAA450.status.value
        return status_code == statusStopped || status_code == statusOpen || status_code == statusUnknown
    }

    contentComponent: Component {
        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            SettingsGroupLayout {
                heading: getPanelName()

                LabelledLabel {
                    label:      qsTr("Status")
                    labelText:  getLidarStatusString()
                }

                LabelledLabel {
                    label:      qsTr("Hint")
                    labelText:  getStatusHint()
                }

                GridLayout {
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    QGCButton {
                        text: qsTr("Create project")
                        onClicked: { _activeVehicle.lidarSendCommand(cmdCreateProject) }
                        enabled: isCreateCommandEnabled()
                    }
                    QGCButton {
                        text: qsTr("Start capturing")
                        onClicked: { _activeVehicle.lidarSendCommand(cmdStartCapturing) }
                        enabled: isStartCapturingCommandEnabled()
                    }
                }

                GridLayout {
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    QGCButton {
                        text: qsTr("Stop capturing")
                        onClicked: { _activeVehicle.lidarSendCommand(cmdStopCapturing) }
                        enabled: isStopCapturingCommandEnabled()
                    }
                    QGCButton {
                        text: qsTr("Close project")
                        onClicked: { _activeVehicle.lidarSendCommand(cmdCloseProject) }
                        enabled: isCloseProjectCommandEnabled()
                    }
                }

                GridLayout {
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            4
                    visible:            _activeVehicle.chcnavAA450.year.value != 0
                    QGCLabel {
                        text: qsTr("Date:")
                    }
                    QGCLabel {
                        text: _activeVehicle.chcnavAA450.year.value
                    }
                    QGCLabel {
                        text: _activeVehicle.chcnavAA450.month.value
                    }
                    QGCLabel {
                        text: _activeVehicle.chcnavAA450.day.value
                    }
                }

                LabelledLabel {
                    label:      qsTr("Working time:")
                    visible:    _activeVehicle.chcnavAA450.workingTime.value != 0
                    labelText:  _activeVehicle.chcnavAA450.workingTime.value
                }

                LabelledLabel {
                    label:      qsTr("Capturing time:")
                    visible:    _activeVehicle.chcnavAA450.workingTime.value != 0
                    labelText:  _activeVehicle.chcnavAA450.capturingTime.value
                }

                LabelledLabel {
                    label:      qsTr("POS")
                    visible:    false
                    labelText:  "-"
                }

                LabelledLabel {
                    label:      qsTr("Laser")
                    visible:    false
                    labelText:  "-"
                }

                LabelledLabel {
                    label:      qsTr("Camera")
                    visible:    false
                    labelText:  "-"
                }

                LabelledLabel {
                    label:      qsTr("Storage")
                    visible:    false
                    labelText:  "-"
                }

                LabelledLabel {
                    label:      qsTr("Status")
                    visible:    false
                    labelText:  "-"
                }
            }
        }
    }

    expandedComponent: Component {
        SettingsGroupLayout {
            heading:        qsTr("CHCNAV AA450 Settings")

            FactCheckBoxSlider {
                Layout.fillWidth:   true
                text:               qsTr("AutoConnect")
                fact:               QGroundControl.settingsManager.autoConnectSettings.autoConnectRTKGPS
                enabled:            false
            }

            LabelledFactSlider {
                label:                  qsTr("Shutter speed")
                fact:                   rtkSettings.surveyInMinObservationDuration
                enabled:                false
            }

            LabelledFactSlider {
                label:                  qsTr("ISO")
                fact:                   rtkSettings.surveyInMinObservationDuration
                enabled:                false
            }

            RowLayout {
                spacing: ScreenTools.defaultFontPixelWidth

                QGCLabel {
                    text: qsTr("PhotoMode")
                    enabled:                false
                }
                QGCComboBox {
                    id:         photoMode
                    enabled:                false
                    textRole:   "text"
                    model: ListModel {
                        id: windItems
                        ListElement { text: qsTr("Timing");   value: -1 }
                        ListElement { text: qsTr("Calm");     value: 0 }
                        ListElement { text: qsTr("Breeze");   value: 5 }
                        ListElement { text: qsTr("Gale");     value: 8 }
                        ListElement { text: qsTr("Storm");    value: 10 }
                    }
                    onActivated: { }
                    Component.onCompleted: { }
                }
            }

            LabelledFactSlider {
                label:                  qsTr("PhotoGap")
                fact:                   rtkSettings.surveyInMinObservationDuration
                enabled:                false
            }

            LabelledLabel {
                label:      qsTr("Software version")
                labelText:  qsTr("1.0.8")
                enabled:    false
            }
        }
    }
}
