
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
    property var    _siyiCameraInterface:       _multiVehicleManager.siyiCameraInterface
    property var    _activeVehicle:             _multiVehicleManager.activeVehicle
    property var    _settingsManager:           QGroundControl.settingsManager
    property var    _appSettings:               _settingsManager.appSettings
    property var    _payloadSettings:           _settingsManager.payloadSettings
    property bool   _isCamera:                  _payloadSettings.type.rawValue === 0
    property var    _zoomLvl: 1

    FactPanelController { id: controller }

    Rectangle{
        color:      Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
        height:     parent.width
        width:      parent.width

        property bool isClicked: false

        QGCColoredImage {
            source:             "/InstrumentValueIcons/add.svg"
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            color:              "black"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: { 
                _zoomLvl += 1;
                _siyiCameraInterface.zoomIn();
                if (_zoomLvl > zoomSlider.to){
                    _zoomLvl = zoomSlider.to;
                }
            }
        }
    }

    QGCSlider {
        id:                 zoomSlider
        Layout.fillHeight:  true
        Layout.fillWidth:   true
        to:                 _payloadSettings.cameraMaxZoom.rawValue
        from:               1
        stepSize:           1
        orientation:        Qt.Vertical
        value:              _zoomLvl
        live:               true
        displayValue:       true
        onValueChanged:     {if (value == _zoomLvl){} else {_zoomLvl = _siyiCameraInterface.zoomSet(value)}}
    }

    Rectangle{
        color:  Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
        height: parent.width
        width: parent.width

        property bool isClicked: false

        QGCColoredImage {
            source:             "/InstrumentValueIcons/minus.svg"
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            color:              "black"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                _zoomLvl -= 1;
                _siyiCameraInterface.zoomOut();
                if (_zoomLvl < zoomSlider.from){
                    _zoomLvl = zoomSlider.from;
                }
            }
        }
    }
}