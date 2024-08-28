#include <siyi-sdk.h>

class SiyiCameraInterface : public SIYIUnixCamera{
    Q_OBJECT

public:
    SiyiCameraInterface();
    void zoomIn();
    void zoomOut();

private:
    const int maxZoom = 30;
    const int minZoom = 1;
    int currentZoom = 1;
};