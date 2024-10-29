#include <CameraAIController.h>

const char* CameraAIController::_aiTypeFactName = "aiType";

CameraAIController::CameraAIController() : FactGroup(100, ":/json/CameraAIControllerFact.json"){
    // Init facts
    _aiTypeFact = Fact(0, _aiTypeFactName,  FactMetaData::valueTypeUint32);

    _addFact(&_aiTypeFact, _aiTypeFactName);
}