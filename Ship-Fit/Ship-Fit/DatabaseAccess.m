//
//  DatabaseAccess.m
//  Ship-Fit
//
//  Created by hamid on 2013-11-14.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "DatabaseAccess.h"

@implementation DatabaseAccess

FMDatabase* db;

/*
 ------------example------------------:
//insert into weather
 DatabaseAccess *db = [[DatabaseAccess alloc]init];
 
 NSMutableArray * arr3 = [db getWeatherAll];
 WeatherClass *weather = [db getWeatherWithID:(1)];
 
 //insert into the tables
 int lastInsertID = [_DB insertIntoTrips:(@"mytrip")];
 if(lastInsertID){
    [_DB insertIntoGPS:lastInsertID lat:@"32333" lng:@"3232" dateandtime:@"323223"];
 }else{
    NSLog(@"error inserting into GPS table");
 }
 
 //get all the gps coordinates
 GPS *gpsObjects = (GPS *)[_DB getGPSAll];
 for (GPS *gps in gpsObjects) {
    NSLog(@"gps coordinates: %@, %@", gps.lat, gps.lng);
 }

 */


-(id)init{
    self = [super init];
    if ( self ){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:@"shipfitGPS.sqlite"];
        
        db = [FMDatabase databaseWithPath:path];
        
    }
    return self;
}

// [_DB insertIntoGPS:lastInsertID lat:@"32333" lng:@"3232" dateandtime:@"323223"];
-(NSInteger)insertIntoGPS:(NSInteger)tripID lat:(NSString *)lat lng:(NSString *)lng dateandtime:(NSString *)dateandtime{
    
    [db open];
    
    NSString* update = [NSString stringWithFormat:@"INSERT INTO GPS (tripid, lat, lng, dateandtime) VALUES(?, ?, ?, ?);", [NSNumber numberWithInt:tripID], lat, lng, dateandtime];
    [db executeUpdate:update];
    
    
    
    NSInteger lastId = [db lastInsertRowId];
    
    [db close];
    
    return lastId;
}


// [_DB insertIntoTrips:(@"2013-11-27-18:45:53")];
-(NSInteger)insertIntoTrips:(NSString *)startdate{
    
    [db open];

    NSString* update = [NSString stringWithFormat:@"INSERT INTO Trips (startdate) VALUES(?);", startdate];
    [db executeUpdate:update];
    
    
    NSInteger tripId = [db lastInsertRowId];

    [db close];
    
    return tripId;
}

-(NSInteger)getLatestTripID{
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT MAX(id) as id FROM Trips;"];
    
    [db close];
    
    return [results intForColumn:@"id"];
}

/*
GPS *gpsObjects = (GPS *)[_DB getGPSAll];
for (GPS *gps in gpsObjects) {
    NSLog(@"gps coordinates: %@, %@", gps.lat, gps.lng);
}
*/
-(NSMutableArray *) getGPSAll
{
    NSMutableArray *gpsArr = [[NSMutableArray alloc] init];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM GPS"];
    
    
    while([results next])
    {
        GPS *gps = [[GPS alloc] init];
        
        gps.ID = [results intForColumn:@"id"];
        gps.tripID = [results intForColumn:@"tripid"];
        gps.lat = [results stringForColumn:@"lat"];
        gps.lng = [results stringForColumn:@"lng"];
        gps.dateandtime = [results stringForColumn:@"dateandtime"];
        
        [gpsArr addObject:gps];
    }
    
    [db close];
    
    return gpsArr;
}


//get gps coordinates for a particular tirp
// [_DB getGPS:4 ];
-(GPS *) getGPSforTrip:(NSInteger)tripID
{
    NSMutableArray *gpsArr = [[NSMutableArray alloc] init];
    
    [db open];
    
    
    NSString *q = [NSString stringWithFormat:@"select * from GPS where tripid = %d", tripID];
    FMResultSet *results = [db executeQuery:q];
    
    
    
    while([results next])
    {
        GPS *gps = [[GPS alloc] init];
        
        gps.ID = [results intForColumn:@"id"];
        gps.tripID = [results intForColumn:@"tripid"];
        gps.lat = [results stringForColumn:@"lat"];
        gps.lng = [results stringForColumn:@"lng"];
        gps.dateandtime = [results stringForColumn:@"dateandtime"];
        
        [gpsArr addObject:gps];
    }
    
    [db close];
    
    return [gpsArr objectAtIndex:(0)];
}



//INSERT INTO weather (lat, lng, JSON, datetime) VALUES ("3232", "4343", "frefneronfe", "23232")
-(NSInteger)insertIntoWeather:(NSString *)lat lng:(NSString *)lng JSON:(NSString *)JSON dateandtime:(NSString *)dateandtime{
    
    [db open];
    

    NSString* update =  [NSString stringWithFormat:@"INSERT INTO weather (lat, lng, JSON, datetime) VALUES(?, ?, ?, ?);", lat, lng, JSON, dateandtime];

    [db executeUpdate:update];
    
    
    NSInteger lastId = [db lastInsertRowId];
    
    [db close];
    
    return lastId;
}



-(NSMutableArray *) getWeatherAll
{
    NSMutableArray *weatherArr = [[NSMutableArray alloc] init];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM weather"];
    
    while([results next])
    {
        WeatherClass *w = [[WeatherClass alloc] init];
        
        w.ID = [results intForColumn:@"id"];
        w.lat = [results stringForColumn:@"lat"];
        w.lng = [results stringForColumn:@"lng"];
        w.JSON = [results stringForColumn:@"JSON"];
        w.dateandtime = [results stringForColumn:@"datetime"];
        
        [weatherArr addObject:w];
    }
    
    [db close];
    
    return weatherArr;
}




-(WeatherClass *) getWeatherWithID:(NSInteger)weatherID
{
    NSMutableArray *weatherArr = [[NSMutableArray alloc] init];
    
    [db open];
    
    NSString *q = [NSString stringWithFormat:@"select * from weather where id = %d", weatherID];
    FMResultSet *results = [db executeQuery:q];
    
    while([results next])
    {
        WeatherClass *w = [[WeatherClass alloc] init];
        
        w.ID = [results intForColumn:@"id"];
        w.lat = [results stringForColumn:@"lat"];
        w.lng = [results stringForColumn:@"lng"];
        w.JSON = [results stringForColumn:@"JSON"];
        w.dateandtime = [results stringForColumn:@"datetime"];
        
        [weatherArr addObject:w];
    }
    
    [db close];
    
    return [weatherArr objectAtIndex:(0)];
}

@end
