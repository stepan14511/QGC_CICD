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
import QGroundControl.ScreenTools

Item {
    id:     cameraRoot
    width:  size
    height: size

    property real size:     50
    property real percent:  0

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function getColor() {
        var isCameraConnected = true // Future work: make it check if the camera is online
        if (isCameraConnected){
            return Qt.rgba(0,1,0,1)
        } else{
            return Qt.rgba(1,0,0,1)
        }
    }

    QGCColoredImage {
        source:             "/qmlimages/CameraIcon.svg"
        fillMode:           Image.PreserveAspectFit
        anchors.fill:       parent
        color:              getColor()
        sourceSize.height:  size
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(siyiCameraPage, cameraRoot)
    }

    Component {
        id: siyiCameraPage
        SiyiCameraPage { }
    }
}