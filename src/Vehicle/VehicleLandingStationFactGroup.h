/****************************************************************************
 *
 * (c) 2021 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

class Vehicle;

class VehicleLandingStationFactGroup : public FactGroup
{
    Q_OBJECT

public:
    VehicleLandingStationFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* mode               READ mode               CONSTANT)
    Q_PROPERTY(Fact* coverStatus        READ coverStatus        CONSTANT)
    Q_PROPERTY(Fact* droneStatus        READ droneStatus        CONSTANT)
    Q_PROPERTY(Fact* connectionStatus   READ connectionStatus   CONSTANT)
    Q_PROPERTY(Fact* chargingStatus     READ chargingStatus     CONSTANT)
    Q_PROPERTY(Fact* coverCmd           READ coverCmd           CONSTANT)
    Q_PROPERTY(Fact* chargingCmd        READ chargingCmd        CONSTANT)

    Fact* mode                          () { return &_modeFact; }
    Fact* coverStatus                   () { return &_coverStatusFact; }
    Fact* droneStatus                   () { return &_droneStatusFact; }
    Fact* connectionStatus              () { return &_connectionStatusFact; }
    Fact* chargingStatus                () { return &_chargingStatusFact; }
    Fact* coverCmd                      () { return &_coverCmdFact; }
    Fact* chargingCmd                   () { return &_chargingCmdFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;
    void _updateAllValues() override;

    static const char* _modeFactName;
    static const char* _coverStatusFactName;
    static const char* _droneStatusFactName;
    static const char* _connectionStatusFactName;
    static const char* _chargingStatusFactName;
    static const char* _coverCmdFactName;
    static const char* _chargingCmdFactName;

    // Counter indicated how many seconds the current message remains fresh, 0 means not fresh
    uint8_t _msg_freshness_seconds = 0;
private:
    Fact _modeFact;
    Fact _coverStatusFact;
    Fact _droneStatusFact;
    Fact _connectionStatusFact;
    Fact _chargingStatusFact;
    Fact _coverCmdFact;
    Fact _chargingCmdFact;
};
