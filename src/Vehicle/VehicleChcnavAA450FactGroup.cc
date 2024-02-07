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

VehicleChcnavAA450FactGroup::VehicleChcnavAA450FactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/ChcnavAA450FactGroup.json", parent)
    , _statusFact                       (0, _statusFactName,                   FactMetaData::valueTypeUint16)
{
    _addFact(&_statusFact,                 _statusFactName);
    status()->setRawValue                  (65535);
}

void VehicleChcnavAA450FactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_TUNNEL) {
        return;
    }

    mavlink_tunnel_t content;
    mavlink_msg_tunnel_decode(&message, &content);

    status()->setRawValue                  (content.payload[5] + content.payload[6] * 256);
}
