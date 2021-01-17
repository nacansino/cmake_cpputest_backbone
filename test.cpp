/**
 * @file test.cpp
 * @author Niel Cansino (niel.cansino@ali.jp)
 * @brief 
 * @version 0.1
 * @date 2021-01-17
 * 
 * @copyright Copyright (c) 2021 ALI Technologies Inc., All rights reserved.
 * 
 * This source code or any portion thereof must not be  
 * reproduced or used in any manner whatsoever.
 * 
 */
#include <CppUTest/CommandLineTestRunner.h>
#include <CppUTest/TestHarness.h>
#include <CppUTestExt/MockSupport.h>

#include "Module1.hpp"

#include <cstdint>

TEST_GROUP(MyApp_TestGroup)
{
    Module1 myModule;

    void setup()
    {
        
    }

    void teardown()
    {

    }
};

TEST(MyApp_TestGroup, TEST1)
{   
    CHECK(myModule.sampleFunction());
}

int main(int ac, char** av)
{
    
    return CommandLineTestRunner::RunAllTests(ac, av);

}