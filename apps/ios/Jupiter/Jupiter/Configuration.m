//
//  Configuration.m
//  Jupiter
//
//  Created by Matt Ryan on 1/7/14.
//  Copyright (c) 2014 Seventeen Stones. All rights reserved.
//

#import "Configuration.h"

#import <sqlite3.h>

@interface Configuration ()
{
    sqlite3 * _db;
}

@property (strong, nonatomic) NSString * cfgDir;
@property (strong, nonatomic) NSString * createTableFmt;
@property (strong, nonatomic) NSString * insertFmt;
@property (strong, nonatomic) NSString * selectFmt;

@end

@implementation Configuration

- (id) init
{
    if (self = [super init])
    {
        self.createTableFmt = @"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY ASC, %@)";
        self.insertFmt = @"INSERT OR REPLACE INTO %@(%@) VALUES (%@)";
        self.selectFmt = @"SELECT %@ FROM %@ WHERE %@";
        
        // Look for an existing config
        self.cfgDir = [NSHomeDirectory() stringByAppendingPathComponent:@"config.db"];
        
        if (0 != sqlite3_open([self.cfgDir UTF8String], &_db))
        {
            NSLog(@"Failed to open configuration database %@", self.cfgDir);
        }
        else if (0 != [self initializeConfigDb:0])
        {
            NSLog(@"Failed to initialize configuration database");
        }
    }
    return self;
}

- (int) initializeConfigDb:(int)nAttempts
{
    if (++nAttempts > 2)
    {
        return -1;
    }
    
    NSArray * tableNames = [NSArray arrayWithObjects:@"meta", @"properties", nil];
    NSArray * tableFields = [NSArray arrayWithObjects:@"version TEXT", @"propertyName TEXT UNIQUE, propertyValue TEXT", nil];
    NSDictionary * tables = [NSDictionary dictionaryWithObjects:tableFields forKeys:tableNames];
    
    int rv = 0;
    for (NSString * tableName in [tables keyEnumerator])
    {
        // First look for the version table
        // If you can't select from it then create the table
        // If you can, then verify the version - then update it if necessary
        rv = [self sqliteCreateTable:tableName fields:[tables objectForKey:tableName]];
        if (0 != rv)
        {
            return rv;
        }
    }
    
    if (0 == rv)
    {
        NSDictionary * meta = [self rawQueryWithSql:@"select * from meta"
                                          forFields:[NSArray arrayWithObjects:@"id", @"version", nil]];
        if (nil == meta)
        {
            rv = [self sqliteInsertIntoTable:@"meta" fields:@"version" values:@"'1.0'"];
        }
        else if (! [[meta objectForKey:@"id"] isEqualToString:@"1"])
        {
            NSLog(@"Unexpected row count in configuration meta - expected id 1 but found id %@", [meta objectForKey:@"id"]);
            return -1;
        }
        else if (! [[meta objectForKey:@"version"] isEqualToString:@"1.0"])
        {
            NSLog(@"Unexpected configuration version - expected 1.0 but found %@", [meta objectForKey:@"version"]);
            
            // If the version is older, we would upgrade here (future).
            // If the version is newer, this is a problem - we throw everything away and rebuild the database.
            double currentVersion = [[meta objectForKey:@"version"] doubleValue];
            if (currentVersion > 1.0)
            {
                rv = [self rawCommandWithSql:@"DROP TABLE IF EXISTS properties"];
                if (0 == rv)
                {
                    rv = [self rawCommandWithSql:@"DROP TABLE IF EXISTS meta"];
                    if (0 == rv)
                    {
                        rv = [self initializeConfigDb:nAttempts];
                    }
                }
            }
        }
    }
    return rv;
}


- (void) setPropertyNamed:(NSString*)propertyName toStringValue:(NSString*)propertyValue
{
    [self sqliteInsertIntoTable:@"properties"
                         fields:@"propertyName, propertyValue"
                         values:[NSString stringWithFormat:@"'%@', '%@'", propertyName, propertyValue]];
}

- (void) setPropertyNamed:(NSString*)propertyName toIntegerValue:(int)propertyValue
{
    [self setPropertyNamed:propertyName toStringValue:[NSString stringWithFormat:@"%d", propertyValue]];
}

- (void) setPropertyNamed:(NSString*)propertyName toFloatValue:(double)propertyValue
{
    [self setPropertyNamed:propertyName toStringValue:[NSString stringWithFormat:@"%f", propertyValue]];
}

- (void) setPropertyNamed:(NSString*)propertyName toBooleanValue:(BOOL)propertyValue
{
    [self setPropertyNamed:propertyName toStringValue:[NSString stringWithFormat:@"%d", (propertyValue ? 1 : 0)]];
}

- (NSString*) getStringPropertyByName:(NSString*)propertyName
{
    NSDictionary * results = [self sqliteSelectFromTable:@"properties"
                                                  fields:[NSArray arrayWithObject:@"propertyValue"]
                                                 clauses:[NSString stringWithFormat:@"propertyName='%@'", propertyName]];
    if (nil != results)
    {
        id result = [results objectForKey:@"propertyValue"];
        if (nil != result)
        {
            return (NSString *)result;
        }
    }
    return @"";
}

- (int) getIntegerPropertyByName:(NSString*)propertyName
{
    return [[self getStringPropertyByName:propertyName] intValue];
}

- (double) getFloatPropertyByName:(NSString*)propertyName
{
    return [[self getStringPropertyByName:propertyName] doubleValue];
}

- (BOOL) getBooleanPropertyByName:(NSString*)propertyName;
{
    return [[self getStringPropertyByName:propertyName] intValue] == 1 ? YES : NO;
}


- (int) sqliteCreateTable:(NSString *)table fields:(NSString *)fields
{
    int rv = sqlite3_exec(_db, [[NSString stringWithFormat:self.createTableFmt, table, fields] UTF8String],
                          NULL, NULL, NULL);
    if (0 != rv)
    {
        NSLog(@"Failed to create \"%@\" table in configuration database", table);
    }
    return rv;
}

- (int) sqliteInsertIntoTable:(NSString *)table fields:(NSString *)fields values:(NSString *)values
{
    NSString * sql = [NSString stringWithFormat:self.insertFmt, table, fields, values];
    int rv = sqlite3_exec(_db, [sql UTF8String], NULL, NULL, NULL);
    if (0 != rv)
    {
        NSLog(@"Failed to insert fields \"%@\" into  table \"%@\"", fields, table);
        NSLog(@"Error: %s", sqlite3_errmsg(_db));
    }
    return rv;
}

- (NSDictionary *) sqliteSelectFromTable:(NSString*)table
                                  fields:(NSArray*)fields
                                 clauses:(NSString *)clauses
{
    NSString * selectStatement = [NSString stringWithFormat:self.selectFmt,
                                  [fields componentsJoinedByString:@","],
                                  table, clauses];
    return [self rawQueryWithSql:selectStatement forFields:fields];
}

- (NSDictionary*) rawQueryWithSql:(NSString*)sql forFields:(NSArray*)fields
{
    sqlite3_stmt * preparedStatement;

    NSMutableDictionary * results = [[NSMutableDictionary alloc] init];
    
    int rv = sqlite3_prepare(_db, [sql UTF8String],
                             -1, &preparedStatement, nil);
    if (0 == rv)
    {
        while (SQLITE_ROW == sqlite3_step(preparedStatement))
        {
            // We could be more crafty here and switch on sqlite3_column_type to determine the type of the
            // database element.  But for now we are assuming that everything we store is going to be
            // converted to text anyway, so this allows us to keep the database dumb and defer type conversion
            // to the caller who probably knows what it should be anyway.
            
            int columnNumber = 0;
            for (NSString * field in fields) {
                NSString * col =
                [[NSString alloc] initWithUTF8String:((char *) sqlite3_column_text(preparedStatement, columnNumber++))];
                [results setObject:col forKey:field];
            }
        }
        sqlite3_finalize(preparedStatement);
    }
    else
    {
        NSLog(@"Failed to prepare select statement: %@", sql);
    }
    
    return [results count] > 0 ? results : nil;
}

- (int) rawCommandWithSql:(NSString*)sql
{
    return sqlite3_exec(_db, [sql UTF8String], nil, nil, nil);
}

@end
