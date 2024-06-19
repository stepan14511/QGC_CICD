/****************************************************************************
 *
 * (c) 2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleChcnavAA450FactGroup.h"
#include "Vehicle.h"

const char* VehicleChcnavAA450FactGroup::_statusFactName = "status";
const char* VehicleChcnavAA450FactGroup::_yearFactName = "year";
const char* VehicleChcnavAA450FactGroup::_monthFactName = "month";
const char* VehicleChcnavAA450FactGroup::_dayFactName = "day";
const char* VehicleChcnavAA450FactGroup::_mem1FactName = "mem1";
const char* VehicleChcnavAA450FactGroup::_mem2FactName = "mem2";
const char* VehicleChcnavAA450FactGroup::_workingTimeFactName = "workingTime";
const char* VehicleChcnavAA450FactGroup::_openedTimeFactName = "openedTime";
const char* VehicleChcnavAA450FactGroup::_capturingTimeFactName = "capturingTime";

VehicleChcnavAA450FactGroup::VehicleChcnavAA450FactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/ChcnavAA450FactGroup.json", parent)
    , _statusFact                       (0, _statusFactName,                   FactMetaData::valueTypeUint16)
    , _yearFact                         (0, _yearFactName,                     FactMetaData::valueTypeUint16)
    , _monthFact                        (0, _monthFactName,                    FactMetaData::valueTypeUint8)
    , _dayFact                          (0, _dayFactName,                      FactMetaData::valueTypeUint8)
    , _mem1Fact                         (0, _mem1FactName,                     FactMetaData::valueTypeUint32)
    , _mem2Fact                         (0, _mem2FactName,                     FactMetaData::valueTypeUint32)
    , _workingTimeFact                  (0, _workingTimeFactName,              FactMetaData::valueTypeUint32)
    , _openedTimeFact                   (0, _openedTimeFactName,               FactMetaData::valueTypeUint32)
    , _capturingTimeFact                (0, _capturingTimeFactName,            FactMetaData::valueTypeUint32)
{
    _addFact(&_statusFact,                 _statusFactName);
    _addFact(&_yearFact,                   _yearFactName);
    _addFact(&_monthFact,                  _monthFactName);
    _addFact(&_dayFact,                    _dayFactName);
    _addFact(&_mem1Fact,                   _mem1FactName);
    _addFact(&_mem2Fact,                   _mem2FactName);
    _addFact(&_workingTimeFact,            _workingTimeFactName);
    _addFact(&_openedTimeFact,             _openedTimeFactName);
    _addFact(&_capturingTimeFact,          _capturingTimeFactName);

    status()->setRawValue                  (65535);
}

void VehicleChcnavAA450FactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_TUNNEL) {
        return;
    }

    mavlink_tunnel_t content;
    mavlink_msg_tunnel_decode(&message, &content);

    uint16_t status_code = content.payload[5] + content.payload[6] * 256;
    uint16_t year_value = content.payload[18] + content.payload[19] * 256;
    uint32_t mem1_value = content.payload[23] + content.payload[24] * 256 + content.payload[25] * 65536;
    uint32_t mem2_value = content.payload[27] + content.payload[28] * 256 + content.payload[29] * 65536;

    status()->setRawValue                  (status_code);
    year()->setRawValue                    (year_value);
    month()->setRawValue                   (content.payload[20]);
    day()->setRawValue                     (content.payload[21]);
    mem1()->setRawValue                    (mem1_value);
    mem2()->setRawValue                    (mem2_value);

    if (status_code != 65535 && status_code != 1) {
        working_time += 1;
    }

    if (status_code == 512) {
        capturing_time += 1;
    }

    workingTime()->setRawValue             (working_time);
    capturingTime()->setRawValue           (capturing_time);
}
