//
//  Configuration.m
//  Jupiter
//
//  Created by Matt Ryan on 1/7/14.
//  Copyright (c) 2014 Seventeen Stones. All rights reserved.
//

#import "Configuration.h"

@interface Configuration ()

@property (strong, nonatomic) NSString * cfgDir;

@end

@implementation Configuration

- (id) init
{
    if (self = [super init])
    {
        // Look for an existing config
        self.cfgDir = [NSHomeDirectory() stringByAppendingPathComponent:@"config.db"];
        
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:self.cfgDir])
        {
            // Load the existing one
            // If the version number is too old migrate it to the latest version
        }
        else
        {
            // If it doesn't exist create one
        }
    }
    return self;
}

- (void) setPropertyNamed:(NSString*)propertyName toStringValue:(NSString*)propertyValue
{
    
}

- (void) setPropertyNamed:(NSString*)propertyName toIntegerValue:(long)propertyValue
{
    
}

- (void) setPropertyNamed:(NSString*)propertyName toFloatValue:(double)propertyValue
{
    
}

- (void) setPropertyNamed:(NSString*)propertyName toBooleanValue:(bool)propertyValue
{
    
}

- (void) setPropertyNamed:(NSString*)propertyName toObjectValue:(NSObject*)propertyValue
{
    
}

- (NSString*) getStringPropertyByName:(NSString*)propertyName
{
    return @"";
}

- (long) getIntegerPropertyByName:(NSString*)propertyName
{
    return 0;
}

- (double) getFloatPropertyByName:(NSString*)propertyName
{
    return 0.0;
}

- (bool) getBooleanPropertyByName:(NSString*)propertyName;
{
    return false;
}

- (NSObject*) getObjectPropertyByName:(NSString*)propertyName
{
    return nil;
}


@end
