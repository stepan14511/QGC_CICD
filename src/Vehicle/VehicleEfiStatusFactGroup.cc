/****************************************************************************
 *
 * (c) 2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleEfiStatusFactGroup.h"
#include "Vehicle.h"

const char* VehicleEfiStatusFactGroup::_healthFactName =                            "health";
const char* VehicleEfiStatusFactGroup::_rpmFactName =                               "rpm";

VehicleEfiStatusFactGroup::VehicleEfiStatusFactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/EfiStatusFactGroup.json", parent)
    , _healthFact                       (0, _healthFactName,                   FactMetaData::valueTypeUint8)
    , _rpmFact                          (0, _rpmFactName,                      FactMetaData::valueTypeFloat)
{
    _addFact(&_healthFact,                 _healthFactName);
    _addFact(&_rpmFact,                    _rpmFactName);
}

void VehicleEfiStatusFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_EFI_STATUS) {
        return;
    }

    mavlink_efi_status_t content;
    mavlink_msg_efi_status_decode(&message, &content);

    health()->setRawValue                  (content.health);
    rpm()->setRawValue                     (content.rpm);
}
