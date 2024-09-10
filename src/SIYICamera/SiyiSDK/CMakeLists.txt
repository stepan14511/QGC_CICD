add_subdirectory(include/crc)

find_package(Qt6 REQUIRED COMPONENTS Network)

qt_add_library(SiyiSDK STATIC
    include/message.h
    include/sdk.h
    include/SiyiSDK.h
    src/message.cc
    src/sdk.cc
)

target_link_libraries(SiyiSDK
    PUBLIC
        gencrc
        QGC
    PRIVATE
        Settings
        Qt6::Network
)


target_include_directories(SiyiSDK PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

