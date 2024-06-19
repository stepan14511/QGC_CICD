/****************************************************************************
 *
 * (c) 2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
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

Item {
    id:             control
    width:          fuelTankIndicatorRow.width
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function getColor() {
        var percentRemaining = _activeVehicle.fuelTank.percentRemaining
        if(percentRemaining.rawValue > 20) {
            return qgcPal.text
        } else if(percentRemaining.rawValue > 10) {
            return qgcPal.colorOrange
        }

        return qgcPal.colorRed
    }

    function getPercentRemainingText() {
        return _activeVehicle.fuelTank.percentRemaining.valueString + "%"
    }

    function getRemainingFuelText() {
        return _activeVehicle.fuelTank.remainingFuel.valueString + _activeVehicle.fuelTank.remainingFuel.units
    }

    function getTemperatureText() {
        return _activeVehicle.fuelTank.temperature.valueString + "°C"
    }

    Row {
        id:             fuelTankIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom

        QGCColoredImage {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            width:              height
            sourceSize.width:   width
            source:             "/qmlimages/FuelTank.svg"
            fillMode:           Image.PreserveAspectFit
            color:              getColor()
        }

        ColumnLayout {
            id:                     indicatorValuesColumn
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            spacing:                0

            QGCLabel {
                Layout.alignment:       Qt.AlignHCenter
                verticalAlignment:      Text.AlignVCenter
                color:                  getColor()
                text:                   getPercentRemainingText()
                font.pointSize:         ScreenTools.smallFontPointSize
                visible:                true
            }

            QGCLabel {
                Layout.alignment:       Qt.AlignHCenter
                font.pointSize:         ScreenTools.smallFontPointSize
                color:                  getColor()
                text:                   getRemainingFuelText()
                visible:                true
            }

            QGCLabel {
                Layout.alignment:       Qt.AlignHCenter
                font.pointSize:         ScreenTools.smallFontPointSize
                color:                  getColor()
                text:                   getTemperatureText()
                visible:                true
            }
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(fuelTankPage, control)
    }

    Component {
        id: fuelTankPage
        FuelTankPage { }
    }
}
