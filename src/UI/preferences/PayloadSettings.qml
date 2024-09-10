/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
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

SettingsPage {
    property var    _settingsManager:           QGroundControl.settingsManager
    property var    _appSettings:               _settingsManager.appSettings
    property var    _payloadSettings:           _settingsManager.payloadSettings
    property bool   _isCamera:                  _payloadSettings.type.rawValue === 0
    property real   _ipWithPortFieldWidth:      ScreenTools.defaultFontPixelWidth * 25

    SettingsGroupLayout {
        Layout.fillWidth: true

        LabelledFactComboBox {
            Layout.fillWidth:   true
            label:              "Type"//qsTr("Type")
            fact:               _payloadSettings.type
            visible:            fact.visible
            indexModel:         false
        }

        LabelledFactComboBox {
            Layout.fillWidth:   true
            label:              "Camera model"//qsTr("Camera model")
            fact:               _payloadSettings.cameraType
            visible:            _isCamera
            indexModel:         false
        }
    }

    SettingsGroupLayout {
        Layout.fillWidth: true
        visible: _isCamera

        LabelledFactTextField {
            Layout.fillWidth:           true
            textFieldPreferredWidth:    _ipWithPortFieldWidth
            label:                      "IP/PORT"//qsTr("IP/PORT")
            fact:                       _payloadSettings.cameraIpPort
            visible:                    _isCamera
        }

        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              "Max Zoom"//qsTr("Max Zoom")
            fact:               _payloadSettings.cameraMaxZoom
            visible:            _isCamera
        }

        QGCCheckBox {
            text:               "Gimbal Control"//qsTr("Gimbal Control")
            visible:            _isCamera
            checked:            _payloadSettings.enableGimbalControl
            onClicked: {        _payloadSettings.enableGimbalControl.rawValue = checked }
            enabled:            false
        }
    }
}