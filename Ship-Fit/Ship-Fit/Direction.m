
#import "ShipFit.h"
#import "Direction.h"
#import "Location.h"

@implementation Direction
{
    CLLocationManager *_locationManager;
}

- (id) initWithReference: (ShipFit *)reference
{
    self = [super init];
    if ( self ){
        _shipFit_ref = reference;
        _compass_readings = [[NSMutableArray alloc] init ];
        _locationManager = [ [CLLocationManager alloc] init ] ;
        _locationManager.delegate = self;
    }
    return self;
}

- (void)run_compass
{
    if ( [ CLLocationManager headingAvailable ] )
    {
        _locationManager.headingFilter = 2;
        [ _locationManager startUpdatingHeading ];
    }
    else{
        NSLog(@"Compass Not Available");
    }
}

- (void)logHeading: (CLHeading *)heading
{
    // Add the entry
    [self.compass_readings insertObject:heading atIndex:0 ];
    
    // Remove all elements older than 2 minutes
    int i;
    for (i = 0; i < [self.compass_readings count]; i++ )
    {
        CLHeading *info = [self.compass_readings objectAtIndex:i];
        if( [heading.timestamp timeIntervalSince1970] - [info.timestamp timeIntervalSince1970] > 120 )
        {
            [self.compass_readings removeObjectAtIndex:i];
            i--;
        }
    }
    
}

- (BOOL)straight_travel
{
    int l = [self.compass_readings count];
    int o = 0;
    double theBaseReading;
    CLHeading *recent = [self.compass_readings objectAtIndex:0];
    
    if ( self.shipFit_ref.isTrueNorth){
        theBaseReading = recent.trueHeading;
    }
    else{
        theBaseReading = recent.magneticHeading;
    }
    
    while ( o < l )
    {
        recent = [self.compass_readings objectAtIndex:o];
        
        if ( self.shipFit_ref.isTrueNorth )
        {
            if ( (theBaseReading - recent.trueHeading > 7.5 ) || (theBaseReading - recent.trueHeading < -7.5 )  )
            {
                return NO;
            }
        }
        else
        {
            if ( (theBaseReading - recent.magneticHeading > 7.5 ) || (theBaseReading - recent.magneticHeading < -7.5 ) )
            {
                return NO;
            }
        }
        o++;
    }
    NSLog(@"Travelling Straight!!!!!");
    return YES;
}

- (void)halt_compass
{
    [ _locationManager stopUpdatingHeading ];
}

// Delegate Method for Compass Events
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@"%@", newHeading);
    
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [newHeading.timestamp timeIntervalSince1970 ] ) < 60 )
    {
        if ( self.shipFit_ref.isTrueNorth )
        {
            self.shipFit_ref.compassDegrees = newHeading.trueHeading;
        }
        else{
            self.shipFit_ref.compassDegrees = newHeading.magneticHeading;
        }
        
        [ self set_bearing ];
        
        if ( [ self.shipFit_ref get_gps_mode ] != SAILING_STARTUP )
        {
            [self logHeading:newHeading];
        }
    }
    else{
        NSLog(@"Time stamp for the compass is stale. Take the according action");
    }
}


// Sets the properties:
// magnetic_north_bearing
// true_north_bearing
// based on the readings of the compass.
- (void)set_bearing
{
    self.shipFit_ref.compassDirection = [Direction bearing_String:self.shipFit_ref.compassDegrees];
}

+ (NSString*)bearing_String:(double)deg
{
    if( deg >= 337.5 || deg <= 22.5 ) return N;
    else if( deg > 22.5 && deg < 67.5 ) return NE;
    else if( deg >= 67.5 && deg <= 112.5 ) return E;
    else if( deg > 112.5 && deg < 157.5) return SE;
    else if( deg >= 157.5 && deg <= 202.5) return S;
    else if( deg > 202.5 && deg < 247.5 ) return SW;
    else if( deg >= 247.5 && deg <= 292.5) return W;
    else if( deg > 292.5 && deg < 337.5) return NW;
    else return ERROR;
}

// Handling Authorization Status Changes.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Compass Services not determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Compass Services Restricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Compass Services Denied");
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"Compass Services Authorized");
            [self run_compass ];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog( @"COMPASS_ERROR\n%@" , error );
}


@end
