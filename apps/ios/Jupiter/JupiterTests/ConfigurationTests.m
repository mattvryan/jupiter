//
//  ConfigurationTests.m
//  Jupiter
//
//  Created by Matt Ryan on 1/7/14.
//  Copyright (c) 2014 Seventeen Stones. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Configuration.h"

#define STRING_KEY @"com.17stones.jupiterios.tests.cfgTestString"
#define INT_KEY    @"com.17stones.jupiterios.tests.cfgTestInt"
#define DOUBLE_KEY @"com.17stones.jupiterios.tests.cfgTestDouble"
#define BOOL_KEY   @"com.17stones.jupiterios.tests.cfgTestBool"
#define STRING_VAL @"testValue"
#define INT_VAL    17
#define DOUBLE_VAL 17.0
#define BOOL_VAL   YES

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

- (void)deletedb
{
    NSFileManager * manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"config.db"] error:nil];
}

- (void)testInitCreatesEmptyConfigurationStore
{
    [self deletedb];
    
    Configuration * cfg = [[Configuration alloc] init];
    NSDictionary * results = [cfg rawQueryWithSql:@"select * from properties"
                                        forFields:[NSArray arrayWithObjects:@"propertyName", @"propertyValue", nil]];
    STAssertNil(results, @"Initialized database not empty");
}

- (void)testInitDoesntCreateMultipleVersionRows
{
    [self deletedb];
    
    {
        Configuration * cfg = [[Configuration alloc] init];
    }
    {
        Configuration * cfg = [[Configuration alloc] init];
        NSDictionary * results = [cfg rawQueryWithSql:@"select * from meta"
                                            forFields:[NSArray arrayWithObjects:@"id", @"version", nil]];
        STAssertTrue([[results objectForKey:@"id"] isEqualToString:@"1"], @"meta row id != 1");
        STAssertTrue([[results objectForKey:@"version"] isEqualToString:@"1.0"], @"meta version != 1.0");
    }
}

- (void)testSetAndGetStringProperty
{
    [self deletedb];
    
    Configuration * cfg = [[Configuration alloc] init];
    [cfg setPropertyNamed:STRING_KEY toStringValue:STRING_VAL];
    NSString * result = [cfg getStringPropertyByName:STRING_KEY];
    STAssertTrue([result isEqualToString:STRING_VAL], @"String value retrieved from configuration differs from value set");
}

- (void)testSetAndGetIntegerProperty
{
    [self deletedb];
    
    Configuration * cfg = [[Configuration alloc] init];
    [cfg setPropertyNamed:INT_KEY toIntegerValue:INT_VAL];
    int result = [cfg getIntegerPropertyByName:INT_KEY];
    STAssertEquals(INT_VAL, result, @"Int value retrieved from configuration differs from value set");
}

- (void)testSetAndGetDoubleProperty
{
    [self deletedb];
    
    Configuration * cfg = [[Configuration alloc] init];
    [cfg setPropertyNamed:DOUBLE_KEY toIntegerValue:DOUBLE_VAL];
    double result = [cfg getFloatPropertyByName:DOUBLE_KEY];
    STAssertEquals(DOUBLE_VAL, result, @"Float value retrieved from configuration differs from value set");
}

- (void)testSetAndGetBooleanProperty
{
    [self deletedb];
    
    Configuration * cfg = [[Configuration alloc] init];
    [cfg setPropertyNamed:BOOL_KEY toIntegerValue:BOOL_VAL];
    BOOL result = [cfg getBooleanPropertyByName:BOOL_KEY];
    STAssertEquals(BOOL_VAL, result, @"Boolean value retrieved from configuration differs from value set");
}

- (void)testInitUsesExistingConfigurationStore
{
    [self deletedb];
    
    {
        Configuration * cfg = [[Configuration alloc] init];
        [cfg setPropertyNamed:STRING_KEY toStringValue:STRING_VAL];
        [cfg setPropertyNamed:INT_KEY toIntegerValue:INT_VAL];
        [cfg setPropertyNamed:DOUBLE_KEY toFloatValue:DOUBLE_VAL];
        [cfg setPropertyNamed:BOOL_KEY toBooleanValue:BOOL_VAL];
    }
    {
        Configuration * cfg = [[Configuration alloc] init];
        NSString * sresult = [cfg getStringPropertyByName:STRING_KEY];
        STAssertTrue([sresult isEqualToString:STRING_VAL],
                     @"String value retrieved from configuration differs from value set");
        int iresult = [cfg getIntegerPropertyByName:INT_KEY];
        STAssertEquals(INT_VAL, iresult, @"Int value retrieved from configuration differs from value set");
        double dresult = [cfg getFloatPropertyByName:DOUBLE_KEY];
        STAssertEquals(DOUBLE_VAL, dresult, @"Float value retrieved from configuration differs from value set");
        BOOL bresult = [cfg getBooleanPropertyByName:BOOL_KEY];
        STAssertEquals(BOOL_VAL, bresult, @"Boolean value retrieved from configuration differs from value set");
    }
}

- (void)testInitRecreatesEmptyConfigurationStoreIfInvalid
{
    [self deletedb];
    
//    STFail(@"Not implemented");
}

@end
