add_subdirectory(include/crc)

find_package(Qt6 REQUIRED COMPONENTS Network)

qt_add_library(siyi-sdk STATIC
    include/message.hpp
    include/sdk.hpp
    include/siyi-sdk.h
    src/message.cpp
    src/sdk.cpp
)

target_link_libraries(siyi-sdk
    PUBLIC
        gencrc
    PRIVATE
        Qt6::Network
)


target_include_directories(siyi-sdk PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

