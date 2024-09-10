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
DECLARE_SETTINGSFACT_NO_FUNC(PayloadSettings, cameraType)
{
    if (!_cameraTypeFact) {
        _cameraTypeFact = _createSettingsFact(cameraTypeName);
        connect(_cameraTypeFact, &Fact::valueChanged, this, &PayloadSettings::_configChanged);
    }
    return _cameraTypeFact;
}
// DECLARE_SETTINGSFACT(PayloadSettings, cameraIpPort)
DECLARE_SETTINGSFACT_NO_FUNC(PayloadSettings, cameraIpPort)
{
    if (!_cameraIpPortFact) {
        _cameraIpPortFact = _createSettingsFact(cameraIpPortName);
        connect(_cameraIpPortFact, &Fact::valueChanged, this, &PayloadSettings::_configChanged);
    }
    return _cameraIpPortFact;
}
DECLARE_SETTINGSFACT_NO_FUNC(PayloadSettings, cameraMaxZoom)
{
    if (!_cameraMaxZoomFact) {
        _cameraMaxZoomFact = _createSettingsFact(cameraMaxZoomName);
        connect(_cameraMaxZoomFact, &Fact::valueChanged, this, &PayloadSettings::_configChanged);
    }
    return _cameraMaxZoomFact;
}
DECLARE_SETTINGSFACT_NO_FUNC(PayloadSettings, enableGimbalControl)
{
    if (!_enableGimbalControlFact) {
        _enableGimbalControlFact = _createSettingsFact(enableGimbalControlName);
        connect(_enableGimbalControlFact, &Fact::valueChanged, this, &PayloadSettings::_configChanged);
    }
    return _enableGimbalControlFact;
}
DECLARE_SETTINGSFACT(PayloadSettings, isCameraResponding)

void PayloadSettings::_configChanged(QVariant)
{
    emit payloadConfiguredChanged();
}