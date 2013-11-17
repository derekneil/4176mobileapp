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


@interface DatabaseAccess : NSObject

-(id) init;

-(NSMutableArray *) getGPSforTrip:(NSInteger)tripID;

-(NSInteger)getLatestTripID;

-(NSMutableArray *) getGPSAll;

-(NSInteger)insertIntoGPS:(NSInteger)tripID lat:(NSString *)lat lng:(NSString *)lng dateandtime:(NSString *)dateandtime;

-(NSInteger)insertIntoTrips:(NSString *)startdate;


@end
