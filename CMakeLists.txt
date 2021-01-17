# Application Sample build CMake with CppUTest

cmake_minimum_required(VERSION 3.8)   # set minimum

set(MODULE_NAME "Module1")

# App name
project(SAMPLE_${MODULE_NAME} C CXX) # set project name

add_subdirectory(${MODULE_NAME})

#==============================================================
# Compiler standards
#==============================================================
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

#==============================================================
# Compile application code
#==============================================================

add_executable(
    ${PROJECT_NAME}
    myapp.cpp
)

target_include_directories(
    ${PROJECT_NAME} 
    PRIVATE 
    ${MODULE_NAME}/
)

# Link the module
target_link_libraries(${PROJECT_NAME} PUBLIC
    ${MODULE_NAME}
)
