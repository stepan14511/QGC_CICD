#include <SiyiSDK.h>
#include <CameraAIController.h>

class SiyiCameraInterface : public SIYIUnixCamera{
    Q_OBJECT

public:
    SiyiCameraInterface();

    Q_PROPERTY(CameraAIController* cameraAIController READ cameraAIController CONSTANT)

    Q_INVOKABLE void zoomIn();
    Q_INVOKABLE void zoomOut();
    Q_INVOKABLE int zoomSet(int newValue); // return - actual new value (for cases not in legal bounds).
    Q_INVOKABLE void takePhoto();

    Q_INVOKABLE void gimbalOnScreenControl  (float panpct, float tiltpct, bool clickAndPoint, bool clickAndDrag, bool rateControl, bool retract = false, bool neutral = false, bool yawlock = false);
    Q_INVOKABLE void sendPitchBodyYaw       (float pitch, float yaw);
    Q_INVOKABLE void sendPitchAbsoluteYaw   (float pitch, float yaw);
    Q_INVOKABLE void resetGimbal            ();
    Q_INVOKABLE void refreshImageList       ();

    CameraAIController* cameraAIController(){ return _cameraAIController; }

public slots:
    void settingsChanged();
    void firePhotoTakenHandler();

private:
    void setMaxZoom(int);

    CameraAIController* _cameraAIController;

    int maxZoom = 30; // Change only using setMaxZoom(int);
    const int minZoom = 1;
    int currentZoom = 1;

//-----------------------------------------------------------------------------
//      TEMP SOLUTION FOR LESOHRANITEL
//-----------------------------------------------------------------------------

public slots:    
    void onImageDownloaded(QNetworkReply *reply);
    void http_send_telemetry_slot();

signals:
    void http_send_telemetry_signal();

private:
    void odom_sharing_loop(bool &connected);
    void send_odom();

    float odom_sharing_hz = 1;
    std::thread odom_sharing_thread;
    QString bearerToken;
};