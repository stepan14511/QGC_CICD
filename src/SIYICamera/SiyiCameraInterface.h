#include <SiyiSDK.h>

class SiyiCameraInterface : public SIYIUnixCamera{
    Q_OBJECT

public:
    SiyiCameraInterface();
    Q_INVOKABLE void zoomIn();
    Q_INVOKABLE void zoomOut();
    Q_INVOKABLE int zoomSet(int newValue); // return - actual new value (for cases not in legal bounds).
    
    Q_INVOKABLE void gimbalOnScreenControl  (float panpct, float tiltpct, bool clickAndPoint, bool clickAndDrag, bool rateControl, bool retract = false, bool neutral = false, bool yawlock = false);
    Q_INVOKABLE void sendPitchBodyYaw       (float pitch, float yaw);
    Q_INVOKABLE void sendPitchAbsoluteYaw   (float pitch, float yaw);
    Q_INVOKABLE void resetGimbal            ();

public slots:
    void settingsChanged();

private:
    void setMaxZoom(int);

    int maxZoom = 30; // Change only using setMaxZoom(int);
    const int minZoom = 1;
    int currentZoom = 1;
};