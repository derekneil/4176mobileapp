
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
    [ self inandr_compass_and_gps ];
    [ self inandr_weather];
    [ self inandr_Database];
    [ self setApplicationDefaults];
    [ self setUpObservers];
}

- (unsigned short int)get_gps_mode
{
    return _location.GPS_MODE;
}

- (BOOL)currently_sailing_straight
{
    return [_direction straight_travel];
}

- (BOOL)get_weather_status
{
    return _weather.weatherHasArrived;
}

- (void)setApplicationDefaults
{
    /* Set Defaults for Application Start-up */
    self.isTrueNorth = YES;
}

- (void)setUpObservers
{
    // Set up an observer to notify the weather class when we get a valid GPS reading
    [_location addObserver:_weather
               forKeyPath:@"GPSisValid"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
}

- (short int)inandr_compass_and_gps
{
    NSLog(@"initializing and running GPS");
    _location = [ [Location alloc] initWithReference:self ];
    [_location init_GPSLOGS];
    _location.GPS_MODE = GPS_ALL;
    [_location run_GPS:nil ];
    
    NSLog(@"initializing and running compass");
    _direction = [ [Direction alloc] initWithReference:self ];
    [ _direction run_compass ];
   return 1; 
}

- (short int)inandr_Database
{
    NSLog(@"initializing Database Access");
    _DB = [[DatabaseAccess alloc] init];
    _tripID = [_DB getLatestTripID];
    return 1;
}

- (short int)inandr_weather
{
    NSLog(@"initializing weather");
    _weather = [ [Weather alloc] initWithReference:self ];
    return 1;
}


@end



