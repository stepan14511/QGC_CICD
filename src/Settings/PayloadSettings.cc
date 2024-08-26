#include "PayloadSettings.h"
#include <QtQml/QQmlEngine>

DECLARE_SETTINGGROUP(Payload, "Payload"){
    qmlRegisterUncreatableType<PayloadSettings>("QGroundControl.SettingsManager", 1, 0, "PayloadSettings", "Reference only");
}

DECLARE_SETTINGSFACT(PayloadSettings, type)
DECLARE_SETTINGSFACT(PayloadSettings, cameraType)
DECLARE_SETTINGSFACT(PayloadSettings, cameraIpPort)
DECLARE_SETTINGSFACT(PayloadSettings, cameraMaxZoom)
DECLARE_SETTINGSFACT(PayloadSettings, enableGimbalControl)