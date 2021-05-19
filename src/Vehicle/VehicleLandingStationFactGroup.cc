/****************************************************************************
 *
 * (c) 2021 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleLandingStationFactGroup.h"
#include "Vehicle.h"

const char* VehicleLandingStationFactGroup::_modeFactName =                             "mode";
const char* VehicleLandingStationFactGroup::_coverStatusFactName =                      "coverStatus";
const char* VehicleLandingStationFactGroup::_droneStatusFactName =                      "droneStatus";
const char* VehicleLandingStationFactGroup::_connectionStatusFactName =                 "connectionStatus";
const char* VehicleLandingStationFactGroup::_chargingStatusFactName =                   "chargingStatus";
const char* VehicleLandingStationFactGroup::_coverCmdFactName =                         "coverCmd";
const char* VehicleLandingStationFactGroup::_chargingCmdFactName =                      "chargingCmd";


VehicleLandingStationFactGroup::VehicleLandingStationFactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/LandingStationFactGroup.json", parent)
    , _modeFact                         (0, _modeFactName,                      FactMetaData::valueTypeUint8)
    , _coverStatusFact                  (0, _coverStatusFactName,               FactMetaData::valueTypeUint8)
    , _droneStatusFact                  (0, _droneStatusFactName,               FactMetaData::valueTypeUint8)
    , _connectionStatusFact             (0, _connectionStatusFactName,          FactMetaData::valueTypeUint8)
    , _chargingStatusFact               (0, _chargingStatusFactName,            FactMetaData::valueTypeUint8)
    , _coverCmdFact                     (0, _coverCmdFactName,                  FactMetaData::valueTypeUint8)
    , _chargingCmdFact                  (0, _chargingCmdFactName,               FactMetaData::valueTypeUint8)
{
    _addFact(&_modeFact,                        _modeFactName);
    _addFact(&_coverStatusFact,                 _coverStatusFactName);
    _addFact(&_droneStatusFact,                 _droneStatusFactName);
    _addFact(&_connectionStatusFact,            _connectionStatusFactName);
    _addFact(&_chargingStatusFact,              _chargingStatusFactName);
    _addFact(&_coverCmdFact,                    _coverCmdFactName);
    _addFact(&_chargingCmdFact,                 _chargingCmdFactName);
}

void VehicleLandingStationFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_LANDING_STATION_STATUS) {
        return;
    }

    _msg_freshness_seconds = 3;

    mavlink_landing_station_status_t content;
    mavlink_msg_landing_station_status_decode(&message, &content);

    coverStatus()->setRawValue                  (content.cover_status);
    chargingStatus()->setRawValue               (content.charging_status);
}

void VehicleLandingStationFactGroup::_updateAllValues()
{
    if (_msg_freshness_seconds != 0) {
        _msg_freshness_seconds--;
        connectionStatus()->setRawValue         (true);
    } else {
        connectionStatus()->setRawValue         (false);
    }

    FactGroup::_updateAllValues();
}
