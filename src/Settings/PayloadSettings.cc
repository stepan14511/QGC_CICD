#include "PayloadSettings.h"
#include <QtQml/QQmlEngine>

DECLARE_SETTINGGROUP(Payload, "Payload"){
    qmlRegisterUncreatableType<PayloadSettings>("QGroundControl.SettingsManager", 1, 0, "PayloadSettings", "Reference only");
}

// DECLARE_SETTINGSFACT(PayloadSettings, type)
DECLARE_SETTINGSFACT_NO_FUNC(PayloadSettings, type)
{
    if (!_typeFact) {
        _typeFact = _createSettingsFact(typeName);
        connect(_typeFact, &Fact::valueChanged, this, &PayloadSettings::_configChanged);
    }
    return _typeFact;
}
DECLARE_SETTINGSFACT(PayloadSettings, cameraType)
// DECLARE_SETTINGSFACT(PayloadSettings, cameraIpPort)
DECLARE_SETTINGSFACT_NO_FUNC(PayloadSettings, cameraIpPort)
{
    if (!_cameraIpPortFact) {
        _cameraIpPortFact = _createSettingsFact(cameraIpPortName);
        connect(_cameraIpPortFact, &Fact::valueChanged, this, &PayloadSettings::_configChanged);
    }
    return _cameraIpPortFact;
}
DECLARE_SETTINGSFACT(PayloadSettings, cameraMaxZoom)
DECLARE_SETTINGSFACT(PayloadSettings, enableGimbalControl)

void PayloadSettings::_configChanged(QVariant)
{
    emit payloadConfiguredChanged();
}