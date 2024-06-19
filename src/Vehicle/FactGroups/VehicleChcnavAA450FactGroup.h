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
    Q_PROPERTY(Fact* year               READ year               CONSTANT)
    Q_PROPERTY(Fact* month              READ month              CONSTANT)
    Q_PROPERTY(Fact* day                READ day                CONSTANT)
    Q_PROPERTY(Fact* mem1               READ mem1               CONSTANT)
    Q_PROPERTY(Fact* mem2               READ mem2               CONSTANT)
    Q_PROPERTY(Fact* workingTime        READ workingTime        CONSTANT)
    Q_PROPERTY(Fact* openedTime         READ openedTime         CONSTANT)
    Q_PROPERTY(Fact* capturingTime      READ capturingTime      CONSTANT)

    Fact* status                        () { return &_statusFact; }
    Fact* year                          () { return &_yearFact; }
    Fact* month                         () { return &_monthFact; }
    Fact* day                           () { return &_dayFact; }
    Fact* mem1                          () { return &_mem1Fact; }
    Fact* mem2                          () { return &_mem2Fact; }
    Fact* workingTime                   () { return &_workingTimeFact; }
    Fact* openedTime                    () { return &_openedTimeFact; }
    Fact* capturingTime                 () { return &_capturingTimeFact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _statusFactName;
    static const char* _yearFactName;
    static const char* _monthFactName;
    static const char* _dayFactName;
    static const char* _mem1FactName;
    static const char* _mem2FactName;
    static const char* _workingTimeFactName;
    static const char* _openedTimeFactName;
    static const char* _capturingTimeFactName;

private:
    Fact _statusFact;
    Fact _yearFact;
    Fact _monthFact;
    Fact _dayFact;
    Fact _mem1Fact;
    Fact _mem2Fact;
    Fact _workingTimeFact;
    Fact _openedTimeFact;
    Fact _capturingTimeFact;

    uint32_t working_time{0};
    uint32_t capturing_time{0};
};
