//
//  Configuration.h
//  Jupiter
//
//  Created by Matt Ryan on 1/7/14.
//  Copyright (c) 2014 Seventeen Stones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

- (void)setPropertyNamed:(NSString*)propertyName toStringValue:(NSString*)propertyValue;
- (void)setPropertyNamed:(NSString*)propertyName toIntegerValue:(long)propertyValue;
- (void)setPropertyNamed:(NSString*)propertyName toFloatValue:(double)propertyValue;
- (void)setPropertyNamed:(NSString*)propertyName toBooleanValue:(bool)propertyValue;
- (void)setPropertyNamed:(NSString*)propertyName toObjectValue:(NSObject*)propertyValue;

- (NSString*) getStringPropertyByName:  (NSString*)propertyName;
- (long)      getIntegerPropertyByName: (NSString*)propertyName;
- (double)    getFloatPropertyByName:   (NSString*)propertyName;
- (bool)      getBooleanPropertyByName: (NSString*)propertyName;
- (NSObject*) getObjectPropertyByName:  (NSString*)propertyName;

@end
