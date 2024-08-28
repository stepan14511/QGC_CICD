add_subdirectory(siyi-sdk)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Network)

qt_add_library(SiyiCameraInterface STATIC
    SiyiCameraInterface.cc
    SiyiCameraInterface.h
)

target_link_libraries(SiyiCameraInterface
    PUBLIC
        siyi-sdk
        Qt6::Network
)

target_include_directories(SiyiCameraInterface PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
