#pragma once

#include "SettingsGroup.h"

class PayloadSettings : public SettingsGroup
{
    Q_OBJECT

public:
    PayloadSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(type)
    DEFINE_SETTINGFACT(cameraType)
    DEFINE_SETTINGFACT(cameraIpPort)
    DEFINE_SETTINGFACT(cameraMaxZoom)
    DEFINE_SETTINGFACT(enableGimbalControl)
    DEFINE_SETTINGFACT(isCameraResponding)

signals:
    void payloadConfiguredChanged    ();

private slots:
    void _configChanged             (QVariant value);
};