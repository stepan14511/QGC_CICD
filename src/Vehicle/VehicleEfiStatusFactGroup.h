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

class VehicleEfiStatusFactGroup : public FactGroup
{
    Q_OBJECT

public:
    VehicleEfiStatusFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* health             READ health             CONSTANT)
    Q_PROPERTY(Fact* rpm                READ rpm                CONSTANT)

    Fact* health                        () { return &_healthFact; }
    Fact* rpm                           () { return &_rpmFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _healthFactName;
    static const char* _rpmFactName;

private:
    Fact _healthFact;
    Fact _rpmFact;
};
