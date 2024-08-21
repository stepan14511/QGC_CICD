#include <siyi-sdk.h>

class SiyiCameraInterface : public SIYIUnixCamera{
public:
    explicit SiyiCameraInterface(const char *ip_address = "192.168.144.25", int port = 37260);
    void zoomIn();
    void zoomOut();

private:
    const int maxZoom = 30;
    const int minZoom = 1;
    int currentZoom = 1;

};