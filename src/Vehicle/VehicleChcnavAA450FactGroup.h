/****************************************************************************
 *
 * (c) 2022 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

class Vehicle;

class VehicleChcnavAA450FactGroup : public FactGroup
{
    Q_OBJECT

public:
    VehicleChcnavAA450FactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* status             READ status             CONSTANT)

    Fact* status                        () { return &_statusFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _statusFactName;

private:
    Fact _statusFact;
};
