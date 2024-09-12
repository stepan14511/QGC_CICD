
import QtQuick
import QtPositioning
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Controls
import QGroundControl.Palette
import QGroundControl.Vehicle
import QGroundControl.Controllers
import QGroundControl.FactSystem
import QGroundControl.FactControls

ColumnLayout{
    
    visible:    _isCamera

    property var    _multiVehicleManager:       QGroundControl.multiVehicleManager
    property var    _activeVehicle:             _multiVehicleManager.activeVehicle
    property var    _settingsManager:           QGroundControl.settingsManager
    property var    _appSettings:               _settingsManager.appSettings
    property var    _payloadSettings:           _settingsManager.payloadSettings
    property bool   _isCamera:                  _payloadSettings.type.rawValue === 0
    property var    _zoomLvl: 1

    // height: parent.height
    // width: parent.width
    // color:      Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)

    FactPanelController { id: controller }

    Rectangle{
        color:      Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
        height:     parent.width
        width:      parent.width

        property bool isClicked: false

        // Text{
        //     anchors.fill: parent
        //     text: parent.isClicked ? "+" : "-"
        //     fontSizeMode: Text.Fit
        //     minimumPixelSize: 8
        //     font.pixelSize: 72
        //     horizontalAlignment: Text.AlignHCenter
        //     verticalAlignment: Text.AlignVCenter
        // }

        QGCColoredImage {
            source:             "/InstrumentValueIcons/add.svg"
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            color:              "black"
            // sourceSize.height:  size
        }
        MouseArea{
            anchors.fill: parent
            onClicked: { _zoomLvl += 1; _multiVehicleManager.siyiCameraZoomIn() }
        }
    }
    // FactSlider {
    //     Layout.fillHeight:  true
    //     Layout.fillWidth:   true
    //     orientation:        Qt.Vertical
    //     enabled:            responsivenessCheckBox.checked
    //     fact:               zoomLvl
    //     from:               1
    //     to:                 30
    //     stepSize:           1
    // }
    QGCSlider {
        Layout.fillHeight:  true
        Layout.fillWidth:   true
        to:                 30
        from:               1
        stepSize:           1
        orientation:        Qt.Vertical
        value:              _zoomLvl
        live:               true
        displayValue:       true
        //visible:            _camera.thermalStreamInstance && _camera.thermalMode === MavlinkCameraControl.THERMAL_BLEND
        onValueChanged:     {_zoomLvl = value}
    }
    // Rectangle{
    //     color: Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
    //     Layout.fillHeight: true
    //     width: parent.width
    // }
    Rectangle{
        color:  Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
        height: parent.width
        width: parent.width

        property bool isClicked: false

        // Text{
        //     anchors.fill: parent
        //     text: parent.isClicked ? "+" : "-"
        //     fontSizeMode: Text.VerticalFit
        //     minimumPixelSize: 8
        //     font.pixelSize: 72
        // }


        QGCColoredImage {
            source:             "/InstrumentValueIcons/minus.svg"
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            color:              "black"
            // sourceSize.height:  size
        }
        MouseArea{
            anchors.fill: parent
            onClicked: { _zoomLvl -= 1; _multiVehicleManager.siyiCameraZoomOut() }
        }
    }
}