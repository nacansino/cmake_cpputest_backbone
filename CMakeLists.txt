# generic CMake with CppUTest

cmake_minimum_required(VERSION 3.8)   # set minimum

# App name
project(DEEPX_CT C CXX) # set project name
set(TARGET_BOARD ${APPNAME})

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
# Compile application code
#==============================================================
add_executable(TEST_MYAPP
    test.cpp
    Module1.cpp
)

add_executable(MYAPP
    myapp.cpp
    Module1.cpp
)

# Compile definition example
target_compile_definitions(TEST_MYAPP PUBLIC -DTESTMODE)

#Linking
target_link_libraries(TEST_MYAPP PUBLIC
    CppUTest 
    CppUTestExt
)

add_test(
    NAME TEST_MYAPP
    COMMAND TEST_MYAPP
)