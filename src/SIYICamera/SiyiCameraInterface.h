#include <SiyiSDK.h>

class SiyiCameraInterface : public SIYIUnixCamera{
    Q_OBJECT

public:
    SiyiCameraInterface();
    void zoomIn();
    void zoomOut();

public slots:
    void settingsChanged();

private:
    void setMaxZoom(int);


    int maxZoom = 30; // Change only using setMaxZoom(int);
    const int minZoom = 1;
    int currentZoom = 1;
};