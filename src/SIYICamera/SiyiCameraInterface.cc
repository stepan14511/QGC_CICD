#include <QDebug>
#include <QDateTime>

#include "SiyiCameraInterface.h"
#include "QGCApplication.h"
#include "SettingsManager.h"

void SiyiCameraInterface::zoomIn(){
    currentZoom++;
    if (currentZoom > maxZoom){
        currentZoom = maxZoom;
        return;
    }
    set_absolute_zoom(currentZoom, 0);
    qDebug() << "SIYICameraInterface: Zoom IN. New Value: " << currentZoom;
}

void SiyiCameraInterface::zoomOut(){
    currentZoom--;
    if (currentZoom < minZoom){
        currentZoom = minZoom;
        return;
    }
    set_absolute_zoom(currentZoom, 0);
    qDebug() << "SIYICameraInterface: Zoom OUT. New Value: " << currentZoom;
}

int SiyiCameraInterface::zoomSet(int newValue){
    currentZoom = newValue;
    if (newValue < minZoom){
        currentZoom = minZoom;
    }
    if (newValue > maxZoom){
        currentZoom = maxZoom;
    }
    set_absolute_zoom(currentZoom, 0);
    qDebug() << "SIYICameraInterface: Zoom SET. New Value: " << currentZoom;
    return currentZoom;
}

void SiyiCameraInterface::takePhoto(){
    request_photo();
    qDebug() << "SIYICameraInterface: Take Photo command invoked.";
}

SiyiCameraInterface::SiyiCameraInterface(){
    _cameraAIController = new CameraAIController();
    currentZoom = 1;
    set_absolute_zoom(1, 0);
    settingsChanged();

    QTimer *secTimer = new QTimer(this);
    connect(secTimer, &QTimer::timeout, this, &SIYIUnixCamera::checkConnection);
    secTimer->start(1000);

    connect(qgcApp()->toolbox()->settingsManager()->payloadSettings(), &PayloadSettings::payloadConfiguredChanged, this, &SiyiCameraInterface::settingsChanged);
}

void SiyiCameraInterface::settingsChanged()
{
    setMaxZoom(qgcApp()->toolbox()->settingsManager()->payloadSettings()->cameraMaxZoom()->rawValue().toInt());

    SIYIUnixCamera::settingsChanged();
}

void SiyiCameraInterface::setMaxZoom(int newValue){
    if (newValue < 1){
        qDebug() << "SIYICameraInterface: invalid max zoom value (must be 1 or bigger).";
        qgcApp()->toolbox()->settingsManager()->payloadSettings()->cameraMaxZoom()->setRawValue(1);
        return;
    }

    if (newValue < currentZoom){
        currentZoom = newValue;
        set_absolute_zoom(currentZoom, 0);
    }

    maxZoom = newValue;
}

void SiyiCameraInterface::sendPitchAbsoluteYaw(float pitch, float yaw) {
    set_gimbal_angles(yaw, pitch);
}

void SiyiCameraInterface::sendPitchBodyYaw(float pitch, float yaw) {
    set_gimbal_angles(yaw, pitch);
}

// Pan and tilt comes as +-(0-1)
void SiyiCameraInterface::gimbalOnScreenControl(float panPct, float tiltPct, bool clickAndPoint, bool clickAndDrag, bool rateControl, bool retract, bool neutral, bool yawlock)
{
    float maxSpeed = qgcApp()->toolbox()->settingsManager()->gimbalControllerSettings()->CameraSlideSpeed()->rawValue().toFloat();

    float panIncDesired  = panPct * maxSpeed;
    float tiltIncDesired = tiltPct * maxSpeed;

    set_gimbal_speed(panIncDesired, tiltIncDesired);
}

void SiyiCameraInterface::resetGimbal() {
    request_gimbal_center();
}