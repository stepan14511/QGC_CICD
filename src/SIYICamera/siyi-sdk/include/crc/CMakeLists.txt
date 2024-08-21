qt_add_library(gencrc STATIC
    include/crc.h
    include/crc.c
)

target_include_directories(gencrc PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
