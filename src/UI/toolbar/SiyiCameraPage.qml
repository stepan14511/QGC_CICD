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
    showExpand: false

    function getPanelName() {
        return "Siyi Camera Status v0.0.1"
    }

    function getStatusText() {
        return "Device is online"
    }

    contentComponent: Component {
        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            SettingsGroupLayout {
                heading: getPanelName()

                LabelledLabel {
                    label:      qsTr("Status")
                    labelText:  getStatusText()
                }

                GridLayout {
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    QGCButton {
                        text: qsTr("Zoom IN")
                        onClicked: { _activeVehicle.siyiCameraZoomIn() }
                        //enabled: isCameraOnline()
                    }
                    QGCButton {
                        text: qsTr("Zoom OUT")
                        onClicked: { _activeVehicle.siyiCameraZoomOut() }
                        //enabled: isCameraOnline()
                    }
                }
            }
        }
    }
}