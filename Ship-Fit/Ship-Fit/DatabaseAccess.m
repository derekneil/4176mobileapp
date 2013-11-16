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
 
 DatabaseAccess *obj = [[DatabaseAccess alloc] init];

 //insert into the tables
 int lastInsertID = [obj insertIntoTrips:(@"mytrip")];
 
 if(lastInsertID){
 [obj insertIntoGPS:lastInsertID lat:@"32333" lng:@"3232" dateandtime:@"323223"];
 }else{
 NSLog(@"error inserting into GPS table");
 }
 
 
 //get all the gps coordinates
 DatabaseAccess *obj = [[DatabaseAccess alloc] init];
 GPS *gpsObjects = (GPS *)[obj getGPSAll];
 
 for (GPS *gps in gpsObjects) {
 NSLog(@"gps coordinates: %@, %@", gps.lat, gps.lng);
 }
 
 
 //get a particular gps coordinate
 DatabaseAccess *obj = [[DatabaseAccess alloc] init];
 GPS *gps = (GPS *)[obj getGPS:1];
 
 NSLog(@"gps coordinates: %@, %@", gps.lat, gps.lng);
 
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


-(NSInteger)insertIntoGPS:(NSInteger)tripID lat:(NSString *)lat lng:(NSString *)lng dateandtime:(NSString *)dateandtime{
    
    [db open];
    
    [db executeUpdate:@"INSERT INTO GPS (tripid, lat, lng, dateandtime) VALUES(?, ?, ?, ?);", [NSNumber numberWithInt:tripID], lat, lng, dateandtime];
    
    
    NSInteger lastId = [db lastInsertRowId];
    
    [db close];
    
    return lastId;
}



-(NSInteger)insertIntoTrips:(NSString *)startdate{
    
    //INSERT INTO Trips (startdate) VALUES ("e32e32e32");
    [db executeUpdate:@"INSERT INTO Trips (startdate) VALUES(?);", startdate];
    
    NSInteger tripId = [db lastInsertRowId];
    
    [db close];

    return tripId;
}

-(NSInteger)getLatestTripID{
    
    [db open];
    
    //INSERT INTO Trips (startdate) VALUES ("e32e32e32");
    [db executeUpdate:@"SELECT * FROM Trips;"];
    
    NSInteger tripId = [db lastInsertRowId];
    
    [db close];
    
    return tripId;
}


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
-(GPS *) getGPS:(NSInteger)tripID
{
    //NSString *q = [NSString stringWithFormat:@"select * from GPS where id = %d", tripID];
    
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


@end
