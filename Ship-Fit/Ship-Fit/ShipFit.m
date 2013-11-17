
#import "ShipFit.h"
#import "Location.h"
#import "Direction.h"
#import "Weather.h"

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
    Weather *_weather;
}

- (void)init_and_run_application
{
    /* Set Defaults for Application Start */
    self.isTrueNorth = YES;
    
    
    NSLog(@"initializing Database Access");
    _DB = [[DatabaseAccess alloc] init];
    _tripID = [_DB getLatestTripID];
    
    NSLog(@"initializing GPS");
    _location = [ [Location alloc] initWithReference:self ];
    [_location init_logs_and_manager];
    _location.GPS_MODE = SAILING_STARTUP;
    [_location run_GPS_withAccuracy:kCLLocationAccuracyBest
                  andDistanceFilter:kCLDistanceFilterNone ];
    
    NSLog(@"initializing compass");
    _direction = [ [Direction alloc] initWithReference:self ];
    [ _direction init_logs_and_manager ];
    [ _direction run_compass_withFilter:5 ];
    
    
    NSLog(@"getting weather");
    _weather = [ [Weather alloc] initWithReference:self ];
    [_weather getWeatherForLatitude:45
                          Longitude:-63.5
                               Time:1.0];
}



@end



