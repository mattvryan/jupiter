//
//  Configuration.h
//  Jupiter
//
//  Created by Matt Ryan on 1/7/14.
//  Copyright (c) 2014 Seventeen Stones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

- (void) setPropertyNamed:(NSString*)propertyName toStringValue:(NSString*)propertyValue;
- (void) setPropertyNamed:(NSString*)propertyName toIntegerValue:(int)propertyValue;
- (void) setPropertyNamed:(NSString*)propertyName toFloatValue:(double)propertyValue;
- (void) setPropertyNamed:(NSString*)propertyName toBooleanValue:(BOOL)propertyValue;

- (NSString*) getStringPropertyByName:  (NSString*)propertyName;
- (int)       getIntegerPropertyByName: (NSString*)propertyName;
- (double)    getFloatPropertyByName:   (NSString*)propertyName;
- (BOOL)      getBooleanPropertyByName: (NSString*)propertyName;

- (NSDictionary*) rawQueryWithSql:(NSString*)sql forFields:(NSArray*)fields;
- (int)         rawCommandWithSql:(NSString*)sql;

@end
