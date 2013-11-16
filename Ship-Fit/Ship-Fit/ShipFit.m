
#import "ShipFit.h"
#import "Location.h"
#import "Direction.h"

// Compass Bearing
NSString *const N = @"N";
NSString *const NW = @"NW";
NSString *const W = @"W";
NSString *const SW = @"SW";
NSString *const S = @"S";
NSString *const SE = @"SE";
NSString *const E = @"E";
NSString *const NE = @"NE";
NSString *const ERROR = @"ERROR";




@implementation ShipFit
{
    Location *_location;
    Direction *_direction;
}



- (void)init_and_run_application
{
    /* By default set true north to true */
    self.isTrueNorth = YES;
    
    NSLog(@"initializing GPS");
    _location = [ [Location alloc] initWithReference:self ];
    [_location init_logs_and_manager];
    [_location run_GPS_withAccuracy:kCLLocationAccuracyBest
                 andDistanceFilter:kCLDistanceFilterNone ];
    
    NSLog(@"initializing compass");
    _direction = [ [Direction alloc] initWithReference:self ];
    [ _direction init_logs_and_manager ];
    [ _direction run_compass_withFilter:5 ];
    
    
    NSLog(@"initializing Database Access");
    _DB = [[DatabaseAccess alloc] init];
    _tripID = [_DB getLatestTripID];
    
}








@end

// Reminder: declare and use macros to define the granularity of GPS and Compass
// Perhaps have a power saver mode.


