add_subdirectory(SiyiSDK)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Network)

qt_add_library(SiyiCameraInterface STATIC
    SiyiCameraInterface.cc
    SiyiCameraInterface.h
)

target_link_libraries(SiyiCameraInterface
    PUBLIC
        Settings
        SiyiSDK
        Qt6::Network
)

target_include_directories(SiyiCameraInterface PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
