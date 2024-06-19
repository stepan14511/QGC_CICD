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
    width:          height
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function getLidarStatusTextShort() {
        var lidarStatusString = "-"
        var status_code = _activeVehicle.chcnavAA450.status.value

        if(status_code == 1)         { lidarStatusString = "WAIT" }
        else if(status_code == 0)    { lidarStatusString = "INITED" }
        else if(status_code == 257)  { lidarStatusString = "WAIT" }
        else if(status_code == 5121) { lidarStatusString = "WAIT" }
        else if(status_code == 5120) { lidarStatusString = "OPEN" }
        else if(status_code == 513)  { lidarStatusString = "WAIT" }
        else if(status_code == 512)  { lidarStatusString = "CAPTURING" }
        else if(status_code == 769)  { lidarStatusString = "WAIT" }
        else if(status_code == 5377) { lidarStatusString = "WAIT" }
        else if(status_code == 5376) { lidarStatusString = "STOPPED" }
        else if(status_code == 1025) { lidarStatusString = "WAIT" }
        else if(status_code == 5632) { lidarStatusString = "CLOSED" }
        else                         { lidarStatusString = "OFF"}

        return ""
    }

    Image {
        id:                 indicatorIcon
        anchors.fill:       parent
        source:             "/qmlimages/ChcnavAA450.svg"
        sourceSize.height:  height
        fillMode:           Image.PreserveAspectFit
    }

    Column {
        id:                     indicatorValuesColumn
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth / 2
        anchors.left:           indicatorIcon.right

        QGCLabel {
            anchors.left:               indicatorIcon.right
            visible:                    _activeVehicle
            color:                      qgcPal.buttonText
            text:                       getLidarStatusTextShort()
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(chcnavAA450Page, control)
    }

    Component {
        id: chcnavAA450Page
        ChcnavAA450Page { }
    }
}
