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
const char* VehicleLandingStationFactGroup::_landingStationStatusFactName =             "landingStationStatus";
const char* VehicleLandingStationFactGroup::_coverStatusFactName =                      "coverStatus";
const char* VehicleLandingStationFactGroup::_elevatorStatusFactName =                   "elevatorStatus";
const char* VehicleLandingStationFactGroup::_centeringMechanismStatusFactName =         "centeringMechanismStatus";
const char* VehicleLandingStationFactGroup::_droneStatusFactName =                      "droneStatus";
const char* VehicleLandingStationFactGroup::_connectionStatusFactName =                 "connectionStatus";
const char* VehicleLandingStationFactGroup::_chargingStatusFactName =                   "chargingStatus";
const char* VehicleLandingStationFactGroup::_coverCmdFactName =                         "coverCmd";
const char* VehicleLandingStationFactGroup::_chargingCmdFactName =                      "chargingCmd";


VehicleLandingStationFactGroup::VehicleLandingStationFactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/LandingStationFactGroup.json", parent)
    , _modeFact                         (0, _modeFactName,                      FactMetaData::valueTypeUint8)
    , _landingStationStatusFact         (0, _landingStationStatusFactName,      FactMetaData::valueTypeUint8)
    , _coverStatusFact                  (0, _coverStatusFactName,               FactMetaData::valueTypeUint8)
    , _elevatorStatusFact               (0, _elevatorStatusFactName,            FactMetaData::valueTypeUint8)
    , _centeringMechanismStatusFact     (0, _centeringMechanismStatusFactName,  FactMetaData::valueTypeUint8)
    , _droneStatusFact                  (0, _droneStatusFactName,               FactMetaData::valueTypeUint8)
    , _connectionStatusFact             (0, _connectionStatusFactName,          FactMetaData::valueTypeUint8)
    , _chargingStatusFact               (0, _chargingStatusFactName,            FactMetaData::valueTypeUint8)
    , _coverCmdFact                     (0, _coverCmdFactName,                  FactMetaData::valueTypeUint8)
    , _chargingCmdFact                  (0, _chargingCmdFactName,               FactMetaData::valueTypeUint8)
{
    _addFact(&_modeFact,                        _modeFactName);
    _addFact(&_landingStationStatusFact,        _landingStationStatusFactName);
    _addFact(&_coverStatusFact,                 _coverStatusFactName);
    _addFact(&_elevatorStatusFact,              _elevatorStatusFactName);
    _addFact(&_centeringMechanismStatusFact,    _centeringMechanismStatusFactName);
    _addFact(&_droneStatusFact,                 _droneStatusFactName);
    _addFact(&_connectionStatusFact,            _connectionStatusFactName);
    _addFact(&_chargingStatusFact,              _chargingStatusFactName);
    _addFact(&_coverCmdFact,                    _coverCmdFactName);
    _addFact(&_chargingCmdFact,                 _chargingCmdFactName);
}

void VehicleLandingStationFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid == MAVLINK_MSG_ID_LANDING_STATION_STATUS) {
        _msg_freshness_seconds = 3;
        _landing_station_status_freshness_seconds = 3;
        mavlink_landing_station_status_t content;
        mavlink_msg_landing_station_status_decode(&message, &content);
        landingStationStatus()->setRawValue             (content.cover_status);
    } else if (message.msgid == MAVLINK_MSG_ID_LANDING_STATION_COVER_STATUS) {
        _msg_freshness_seconds = 3;
        _cover_status_freshness_seconds = 3;
        mavlink_landing_station_cover_status_t content;
        mavlink_msg_landing_station_cover_status_decode(&message, &content);
        coverStatus()->setRawValue                      (content.status);
    } else if (message.msgid == MAVLINK_MSG_ID_LANDING_STATION_ELEVATOR_STATUS) {
        _msg_freshness_seconds = 3;
        _elevator_status_freshness_seconds = 3;
        mavlink_landing_station_elevator_status_t content;
        mavlink_msg_landing_station_elevator_status_decode(&message, &content);
        elevatorStatus()->setRawValue                   (content.status);
    } else if (message.msgid == MAVLINK_MSG_ID_LANDING_STATION_CENTERING_MECHANISM_STATUS) {
        _msg_freshness_seconds = 3;
        _centering_mechanism_status_freshness_seconds = 3;
        mavlink_landing_station_centering_mechanism_status_t content;
        mavlink_msg_landing_station_centering_mechanism_status_decode(&message, &content);
        centeringMechanismStatus()->setRawValue         (content.status);
    } else if (message.msgid == MAVLINK_MSG_ID_LANDING_STATION_CHARGING_STATUS) {
        _msg_freshness_seconds = 3;
        _charging_status_freshness_seconds = 3;
        mavlink_landing_station_charging_status_t content;
        mavlink_msg_landing_station_charging_status_decode(&message, &content);
        chargingStatus()->setRawValue                   (content.status);
    }
}

void VehicleLandingStationFactGroup::_updateAllValues()
{
    if (_msg_freshness_seconds != 0) {
        _msg_freshness_seconds--;
        connectionStatus()->setRawValue             (true);
    } else {
        connectionStatus()->setRawValue             (false);
    }

    if (_landing_station_status_freshness_seconds != 0) {
        _landing_station_status_freshness_seconds--;
    } else {
        landingStationStatus()->setRawValue         (NO_DATA);
    }

    if (_cover_status_freshness_seconds != 0) {
        _cover_status_freshness_seconds--;
    } else {
        coverStatus()->setRawValue                  (NO_DATA);
    }

    if (_elevator_status_freshness_seconds != 0) {
        _elevator_status_freshness_seconds--;
    } else {
        elevatorStatus()->setRawValue               (NO_DATA);
    }

    if (_centering_mechanism_status_freshness_seconds != 0) {
        _centering_mechanism_status_freshness_seconds--;
    } else {
        centeringMechanismStatus()->setRawValue     (NO_DATA);
    }

    if (_charging_status_freshness_seconds != 0) {
        _charging_status_freshness_seconds--;
    } else {
        chargingStatus()->setRawValue               (NO_DATA);
    }

    FactGroup::_updateAllValues();
}
