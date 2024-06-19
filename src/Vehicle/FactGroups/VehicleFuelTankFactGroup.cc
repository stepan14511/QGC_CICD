/****************************************************************************
 *
 * (c) 2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleFuelTankFactGroup.h"
#include "Vehicle.h"

const char* VehicleFuelTankFactGroup::_idFactName = "id";
const char* VehicleFuelTankFactGroup::_maximumFuelFactName = "maximumFuel";
const char* VehicleFuelTankFactGroup::_consumedFuelFactName = "consumedFuel";
const char* VehicleFuelTankFactGroup::_remainingFuelFactName = "remainingFuel";
const char* VehicleFuelTankFactGroup::_percentRemainingFactName = "percentRemaining";
const char* VehicleFuelTankFactGroup::_flowRateFactName = "flowRate";
const char* VehicleFuelTankFactGroup::_temperatureFactName = "temperature";
const char* VehicleFuelTankFactGroup::_fuelTypeFactName = "fuelType";

VehicleFuelTankFactGroup::VehicleFuelTankFactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/FuelTankFactGroup.json", parent)
    , _idFact                           (0, _idFactName,                       FactMetaData::valueTypeUint8)
    , _maximumFuelFact                  (0, _maximumFuelFactName,              FactMetaData::valueTypeFloat)
    , _consumedFuelFact                 (0, _consumedFuelFactName,             FactMetaData::valueTypeFloat)
    , _remainingFuelFact                (0, _remainingFuelFactName,            FactMetaData::valueTypeFloat)
    , _percentRemainingFact             (0, _percentRemainingFactName,         FactMetaData::valueTypeUint8)
    , _flowRateFact                     (0, _flowRateFactName,                 FactMetaData::valueTypeFloat)
    , _temperatureFact                  (0, _temperatureFactName,              FactMetaData::valueTypeFloat)
    , _fuelTypeFact                     (0, _fuelTypeFactName,                 FactMetaData::valueTypeUint32)
{
    _addFact(&_idFact,                  _idFactName);
    _addFact(&_maximumFuelFact,         _maximumFuelFactName);
    _addFact(&_consumedFuelFact,        _consumedFuelFactName);
    _addFact(&_remainingFuelFact,       _remainingFuelFactName);
    _addFact(&_percentRemainingFact,    _percentRemainingFactName);
    _addFact(&_maximumFuelFact,         _maximumFuelFactName);
    _addFact(&_temperatureFact,         _temperatureFactName);
    _addFact(&_fuelTypeFact,            _fuelTypeFactName);
}

void VehicleFuelTankFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_FUEL_STATUS) {
        return;
    }

    mavlink_fuel_status_t content;
    mavlink_msg_fuel_status_decode(&message, &content);

    maximumFuel()->setRawValue          (content.maximum_fuel);
    consumedFuel()->setRawValue         (content.consumed_fuel);
    remainingFuel()->setRawValue        (content.remaining_fuel);
    flowRate()->setRawValue             (content.flow_rate);
    temperature()->setRawValue          (content.temperature);
    fuelType()->setRawValue             (content.fuel_type);
    id()->setRawValue                   (content.id);
    percentRemaining()->setRawValue     (content.percent_remaining);
}
