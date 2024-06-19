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
        return "Fuel Tank Status v0.0.3"
    }

    function getIdValue() {
        return _activeVehicle.fuelTank.id.valueString
    }

    function getPercentRemainingText() {
        return _activeVehicle.fuelTank.percentRemaining.valueString + _activeVehicle.fuelTank.percentRemaining.units
    }

    function getTemperatureText() {
        return _activeVehicle.fuelTank.temperature.valueString + _activeVehicle.fuelTank.temperature.units
    }

    function getFuelTypeText() {
        return _activeVehicle.fuelTank.fuelType.enumStringValue
    }

    contentComponent: Component {
        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            SettingsGroupLayout {
                heading: getPanelName()

                LabelledLabel {
                    label:      qsTr("id")
                    labelText:  getIdValue()
                }

                LabelledLabel {
                    label:      qsTr("Maximum fuel")
                    labelText:  "--.--"
                }

                LabelledLabel {
                    label:      qsTr("Consumed fuel")
                    labelText:  "--.--"
                }

                LabelledLabel {
                    label:      qsTr("Remaining fuel")
                    labelText:  "--.--"
                }

                LabelledLabel {
                    label:      qsTr("Percent remaining")
                    labelText:  getPercentRemainingText()
                }

                LabelledLabel {
                    label:      qsTr("Flow rate")
                    labelText:  "--.--"
                }

                LabelledLabel {
                    label:      qsTr("Temperature")
                    labelText:  getTemperatureText()
                }

                LabelledLabel {
                    label:      qsTr("Fuel type")
                    labelText:  getFuelTypeText()
                }
            }
        }
    }
}
