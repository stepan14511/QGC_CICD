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

SiyiCameraInterface::SiyiCameraInterface() : SIYIUnixCamera(){
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