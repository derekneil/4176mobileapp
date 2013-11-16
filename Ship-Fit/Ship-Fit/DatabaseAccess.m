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
    
    [db executeUpdate:@"INSERT INTO GPS (tripid, lat, lng, dateandtime) VALUES(?, ?, ?, ?);", [NSNumber numberWithInt:tripID], lat, lng, dateandtime];
    
    [db close];
    
    NSInteger lastId = [db lastInsertRowId];
    
    return lastId;
}


// [_DB insertIntoTrips:(@"mytrip")];
-(NSInteger)insertIntoTrips:(NSString *)startdate{
    
    [db open];
    
    //INSERT INTO Trips (startdate) VALUES ("e32e32e32");
    [db executeUpdate:@"INSERT INTO Trips (startdate) VALUES(?);", startdate];
    
    [db close];
    
    NSInteger tripId = [db lastInsertRowId];

    return tripId;
}

-(NSInteger)getLatestTripID{
    
    [db open];
    
    //INSERT INTO Trips (startdate) VALUES ("e32e32e32");
    [db executeUpdate:@"SELECT * FROM Trips;"];
    
    [db close];
    
    NSInteger tripId = [db lastInsertRowId];
    
    return tripId;
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
    
    [db close];
    
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
    
    return gpsArr;
}


//get gps coordinates for a particular tirp
// [_DB getGPS:4 ];
-(NSMutableArray *) getGPS:(NSInteger)tripID
{
    NSMutableArray *gpsArr = [[NSMutableArray alloc] init];
    
    [db open];
    
    
    NSString *q = [NSString stringWithFormat:@"select * from GPS where tripid = %d", tripID];
    FMResultSet *results = [db executeQuery:q];
    
    [db close];
    
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
    
    return gpsArr;
}


@end
