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

class VehicleFuelTankFactGroup : public FactGroup
{
    Q_OBJECT

public:
    VehicleFuelTankFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* id                 READ id                 CONSTANT)
    Q_PROPERTY(Fact* maximumFuel        READ maximumFuel        CONSTANT)
    Q_PROPERTY(Fact* consumedFuel       READ consumedFuel       CONSTANT)
    Q_PROPERTY(Fact* remainingFuel      READ remainingFuel      CONSTANT)
    Q_PROPERTY(Fact* percentRemaining   READ percentRemaining   CONSTANT)
    Q_PROPERTY(Fact* flowRate           READ flowRate           CONSTANT)
    Q_PROPERTY(Fact* temperature        READ temperature        CONSTANT)
    Q_PROPERTY(Fact* fuelType           READ fuelType           CONSTANT)

    Fact* id                            () { return &_idFact; }
    Fact* maximumFuel                   () { return &_maximumFuelFact; }
    Fact* consumedFuel                  () { return &_consumedFuelFact; }
    Fact* remainingFuel                 () { return &_remainingFuelFact; }
    Fact* percentRemaining              () { return &_percentRemainingFact; }
    Fact* flowRate                      () { return &_flowRateFact; }
    Fact* temperature                   () { return &_temperatureFact; }
    Fact* fuelType                      () { return &_fuelTypeFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _idFactName;
    static const char* _maximumFuelFactName;
    static const char* _consumedFuelFactName;
    static const char* _remainingFuelFactName;
    static const char* _percentRemainingFactName;
    static const char* _flowRateFactName;
    static const char* _temperatureFactName;
    static const char* _fuelTypeFactName;

private:
    Fact _idFact;
    Fact _maximumFuelFact;
    Fact _consumedFuelFact;
    Fact _remainingFuelFact;
    Fact _percentRemainingFact;
    Fact _flowRateFact;
    Fact _temperatureFact;
    Fact _fuelTypeFact;
};
