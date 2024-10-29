#pragma once

#include <FactGroup.h>

class CameraAIController : public FactGroup{
    Q_OBJECT

public:
    CameraAIController();

    Q_PROPERTY(Fact* aiType         READ aiType         NOTIFY aiTypeChanged)
    Q_PROPERTY(bool  isEnabled      READ isEnabled      NOTIFY isEnabledChanged)

    Fact* aiType()      { return &_aiTypeFact;  }
    bool isEnabled()    { return _isEnabled;    }

    void  setAiType(int aiType)     { _aiTypeFact.setRawValue(aiType);  }

public slots:
    void updateIsEnabled(const Fact* newAiType) {
        _isEnabled = aiType()->enumStringValue() != "Disabled";
    }

signals:
    void aiTypeChanged(const Fact* newAiType);
    void isEnabledChanged(const bool newIsEnabled);

private:
    // Q_PROPERTIES
    Fact _aiTypeFact;
    bool _isEnabled;

    // Fact names
    static const char* _aiTypeFactName;
};