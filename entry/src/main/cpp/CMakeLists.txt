cmake_minimum_required(VERSION 3.5.0)
project(text_analyzer)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(text_analyzer SHARED
    text_analyzer.cpp
    crypto_utils.cpp
    napi_init.cpp
)

target_link_libraries(text_analyzer PUBLIC
    libace_napi.z.so
    libhilog_ndk.z.so
)
