//
//  DatabaseAccess.h
//  Ship-Fit
//
//  Created by hamid on 2013-11-14.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "GPS.h"
#import "WeatherClass.h"

@interface DatabaseAccess : NSObject

-(id) init;

-(NSInteger)insertIntoGPS:(NSInteger)tripID lat:(NSString *)lat lng:(NSString *)lng dateandtime:(NSString *)dateandtime;

-(NSInteger)insertIntoTrips:(NSString *)startdate;

-(NSInteger)insertIntoWeather:(NSString *)lat lng:(NSString *)lng JSON:(NSString *)JSON dateandtime:(NSString *)dateandtime;

-(GPS *) getGPSforTrip:(NSInteger)tripID;

-(WeatherClass *) getWeatherWithID:(NSInteger)weatherID;

-(NSInteger)getLatestTripID;

-(NSMutableArray *) getGPSAll;

-(NSMutableArray *) getWeatherAll;


@end
