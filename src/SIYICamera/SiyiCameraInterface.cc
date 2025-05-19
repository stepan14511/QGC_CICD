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
    bool isFires = cameraAIController()->aiType()->rawValue() == 2;
    if (isFires){
        connect(this, &SIYIUnixCamera::amountOfImagesChanged,  this, &SiyiCameraInterface::firePhotoTakenHandler);
    }
}

void SiyiCameraInterface::firePhotoTakenHandler(){
    disconnect(this, &SIYIUnixCamera::amountOfImagesChanged,  this, &SiyiCameraInterface::firePhotoTakenHandler);
    auto listOfImages = httpGetListOfImages();
    
    QString url = listOfImages[listOfImages.length()-1].second;
    qDebug() << url;
    downloadImage(url);
}

SiyiCameraInterface::SiyiCameraInterface(){
    _cameraAIController = new CameraAIController();
    currentZoom = 1;
    set_absolute_zoom(1, 0);
    settingsChanged();

    odom_sharing_thread = std::thread([this] { odom_sharing_loop(live); });

    QTimer *secTimer = new QTimer(this);
    connect(secTimer, &QTimer::timeout, this, &SIYIUnixCamera::checkConnection);
    secTimer->start(1000);

    connect(this, &SIYIUnixCamera::onImageDownloadedSignal, this, &SiyiCameraInterface::onImageDownloaded);

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

void SiyiCameraInterface::refreshImageList(){
    httpGetListOfImages();
}

//-----------------------------------------------------------------------------
//      TEMP SOLUTION FOR LESOHRANITEL
//-----------------------------------------------------------------------------
void SiyiCameraInterface::onImageDownloaded(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        // Get token
        QString token = qgcApp()->toolbox()->settingsManager()->payloadSettings()->fireToken()->rawValue().toString();

        QNetworkRequest request;
        request.setUrl(QUrl("https://testing.dev.lesohranitel.ru/app/api/uav/innovtol/events?accessToken=" + token));

        QJsonObject json;
        json["external_id"] = 999;
        json["lon"] = _active_vehicle->longitude();
        json["lat"] = _active_vehicle->latitude();
        json["time"] = QDateTime::currentSecsSinceEpoch();
        json["uav_altitude"] = _active_vehicle->altitudeAMSL()->rawValue().toDouble();
        json["uav_azimuth"] = _active_vehicle->heading()->rawValue().toDouble();
        json["uav_pitch"] = _active_vehicle->pitch()->rawValue().toDouble();
        json["uav_roll"] = _active_vehicle->roll()->rawValue().toDouble();
        json["uav_speed"] = _active_vehicle->groundSpeed()->rawValue().toDouble();
        json["camera_pan"] = bodyYaw()->rawValue().toDouble();
        json["camera_tilt"] = absolutePitch()->rawValue().toDouble();
        json["camera_zoom"] = currentZoom;
        json["image"] = QString((reply->readAll()).toBase64());
        QByteArray data = QJsonDocument(json).toJson();

        // qDebug() << data;

        QNetworkReply *reply = httpNetworkManager->post(request, data);
        
        QObject::connect(reply, &QNetworkReply::finished, [=]() {
        if (reply->error() == QNetworkReply::NoError) {} else {
            // Ошибка
            qDebug() << "Https error (FIRES Camera AI module): " << reply->error() << reply->readAll();
        }
        reply->deleteLater();
    });
    }
    else {
        qDebug() << "Error downloading image:" << reply->errorString();
    }
    reply->deleteLater();
}

void SiyiCameraInterface::odom_sharing_loop(bool &connected) {
    connect(this, &SiyiCameraInterface::http_send_telemetry_signal, this, &SiyiCameraInterface::http_send_telemetry_slot);
    while (connected) {
        bool isFires = cameraAIController()->aiType()->rawValue() == 2;
        if (turnedOn && isFires) {
            emit http_send_telemetry_signal();
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(int(1000 / odom_sharing_hz)));
    }
}

void SiyiCameraInterface::http_send_telemetry_slot(){
    send_odom();
}

void SiyiCameraInterface::send_odom(){
    // Get token
    QString token = qgcApp()->toolbox()->settingsManager()->payloadSettings()->fireToken()->rawValue().toString();

    QNetworkRequest request;
    request.setUrl(QUrl("https://testing.dev.lesohranitel.ru/app/api/uav/innovtol/telemetry?accessToken=" + token));

    QJsonObject json;
    json["external_id"] = 999;
    json["lon"] = _active_vehicle->longitude();
    json["lat"] = _active_vehicle->latitude();
    json["speed"] = _active_vehicle->groundSpeed()->rawValue().toDouble();
    json["time"] = QDateTime::currentSecsSinceEpoch();
    QByteArray data = QJsonDocument(json).toJson();

    QNetworkReply *reply = httpNetworkManager->put(request, data);

    QObject::connect(reply, &QNetworkReply::finished, [=]() {
        if (reply->error() == QNetworkReply::NoError) {} else {
            // Ошибка
            qDebug() << "Https error (FIRES Camera AI module): " << reply->error();
        }
        reply->deleteLater();
    });
}
