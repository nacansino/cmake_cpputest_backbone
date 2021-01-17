# CMake with libraries

cmake_minimum_required(VERSION 3.8)   # set minimum

# Module under test that is typically located
# in ../ (upper directoriy)
set(MODULE_UNDER_TEST "Module1")    

# App name
project(TEST_${MODULE_UNDER_TEST} C CXX)           # set project name

#==============================================================
# Test Configuration
#==============================================================
include(CTest)
enable_testing()

#==============================================================
# Compiler standards
#==============================================================
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)


set(PATH_MODULE_UNDER_TEST ${CMAKE_CURRENT_SOURCE_DIR}/../${MODULE_UNDER_TEST})
add_subdirectory(${PATH_MODULE_UNDER_TEST} ${CMAKE_CURRENT_BINARY_DIR}/${MODULE_UNDER_TEST})

#==============================================================
# Dependency: Test Suite
# This must go before any calls to CppUTest
#==============================================================

if(BUILD_TESTING)
	# Check CppUTest availability
	find_library(cpputest NAMES CppUTest)
	if (NOT cpputest)
	    message(STATUS "Could not locate CppUTest library, fetching CppUTest from Git")
		find_package(Git)
		if(Git_FOUND)
			message(STATUS "Git found, starting fetch")
			include(FetchContent) # Fetch CppUTest
		    FetchContent_Declare(
		        CppUTest
		        GIT_REPOSITORY https://github.com/cpputest/cpputest.git
		        GIT_TAG        latest-passing-build # or use release tag, eg. v3.8
		    )
		    # Set this to ON if you want to have the CppUTests in your project as well.
		    set(TESTS OFF CACHE BOOL "Switch off CppUTest Test build")
		    FetchContent_MakeAvailable(CppUTest)
		    add_definitions(-ln -lg -c -g)
			message(STATUS "CppUTest fetch successful")
		else()
			message(FATAL_ERROR "Git not found, could not continue build")
		endif()
	else()
		message(STATUS "Using locally available CppUTest")	
	endif()
endif()

#==============================================================
# Protobuf
#==============================================================

find_package(Protobuf REQUIRED)

if(protobuf_VERBOSE)
  message(STATUS "Using Protocol Buffers ${Protobuf_VERSION}")
endif()

set(CMAKE_INCLUDE_CURRENT_DIR TRUE)

#==============================================================
# Compile application code
#==============================================================
add_executable(TEST_${MODULE_UNDER_TEST}
    test.cpp
)

# Compile definition example
target_compile_definitions(TEST_${MODULE_UNDER_TEST} PUBLIC -DTESTMODE)

#Linking
target_link_libraries(TEST_${MODULE_UNDER_TEST} PUBLIC
    CppUTest 
    CppUTestExt
    ${MODULE_UNDER_TEST}
)

target_include_directories(
    TEST_${MODULE_UNDER_TEST} 
    PRIVATE 
    ${PATH_MODULE_UNDER_TEST}
)

add_test(
    NAME TEST_${MODULE_UNDER_TEST}
    COMMAND TEST_${MODULE_UNDER_TEST}
)