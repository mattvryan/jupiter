//
//  ConfigurationTests.m
//  Jupiter
//
//  Created by Matt Ryan on 1/7/14.
//  Copyright (c) 2014 Seventeen Stones. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Configuration.h"

@interface ConfigurationTests : SenTestCase

@end

@implementation ConfigurationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitCreatesEmptyConfigurationStore
{
//    STFail(@"Not implemented");
}

- (void)testSetStringProperty
{
    Configuration * cfg = [[Configuration alloc] init];
    [cfg setPropertyNamed:@"com.17stones.jupiterios.tests.cfgTestString" toStringValue:@"testValue"];
    STAssertEquals(@"testValue",
                   [cfg getStringPropertyByName:@"com.17stones.jupiterios.tests.cfgTestString"],
                   @"Configuration failed to set string");
}

- (void)testSetIntegerProperty
{
//    STFail(@"Not implemented");
}

- (void)testSetDoubleProperty
{
//    STFail(@"Not implemented");
}

- (void)testSetBooleanProperty
{
//    STFail(@"Not implemented");
}

- (void)testInitUsesExistingConfigurationStore
{
//    STFail(@"Not implemented");
}

- (void)testInitRecreatesEmptyConfigurationStoreIfInvalid
{
//    STFail(@"Not implemented");
}

- (void)testGetStringProperty
{
//    STFail(@"Not implemented");
}

- (void)testGetIntegerProperty
{
//    STFail(@"Not implemented");
}

- (void)testGetDoubleProperty
{
//    STFail(@"Not implemented");
}

- (void)testGetBooleanProperty
{
//    STFail(@"Not implemented");
}

@end
