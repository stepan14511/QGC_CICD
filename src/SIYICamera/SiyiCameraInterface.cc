#include "SiyiCameraInterface.h"
#include <QDebug>

void SiyiCameraInterface::zoomIn(){
    currentZoom++;
    if (currentZoom > maxZoom){
        currentZoom = maxZoom;
        return;
    }
    set_absolute_zoom(currentZoom, 0);
}

void SiyiCameraInterface::zoomOut(){
    currentZoom--;
    if (currentZoom < minZoom){
        currentZoom = minZoom;
        return;
    }
    set_absolute_zoom(currentZoom, 0);
}

SiyiCameraInterface::SiyiCameraInterface() : SIYIUnixCamera(){
    currentZoom = 1;
    set_absolute_zoom(1, 0);
}
