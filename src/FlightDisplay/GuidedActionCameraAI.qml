import QGroundControl.FlightDisplay
import QGroundControl.Controls

ToolStripAction {

    text:                   qsTr("AI (") + shortAITypeName(getCurrentAiTypeName(cameraAIController.aiType.enumStrings)) + ")"
    iconSource:             "/InstrumentValueIcons/camera.svg"
    visible:                true

    function shortAITypeName(str) {
        if (str === "Disabled"){
            return "-";
        }
        return str.substring(0, 5);
    }

    function getCurrentAiTypeName(arr){
        return arr[cameraAIController.aiType.rawValue];
    }
}