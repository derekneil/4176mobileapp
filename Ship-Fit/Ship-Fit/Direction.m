
#import "ShipFit.h"
#import "Direction.h"

@implementation Direction
{
    CLLocationManager *_locationManager;
}

- (id) initWithReference: (ShipFit *)reference
{
    self = [super init];
    if ( self ){
        _shipFit_ref = reference;
    }
    return self;
}

- (void)init_logs_and_manager
{
    if ( [CLLocationManager locationServicesEnabled ])
    {
        _locationManager = [ [CLLocationManager alloc] init ];
        _locationManager.delegate = self;
        // Havn't set up logs yet. 
    }
}

- (void)run_compass_withFilter: (CLLocationDegrees)compass_accuracy
{
    if ( [ CLLocationManager headingAvailable ] )
    {
        _locationManager.headingFilter = compass_accuracy;
        [ _locationManager startUpdatingHeading ];
    }
    else{
        NSLog(@"Compass Not Available");
    }
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
        if ( self.shipFit_ref.isTrueNorth ){
            self.shipFit_ref.compassDegrees = newHeading.trueHeading;
        }
        else{
            self.shipFit_ref.compassDegrees = newHeading.magneticHeading;
        }
        
        [ self set_bearing ];
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

+ (NSString*)bearing_String:(float)deg
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

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog( @"%@" , error );
}


@end
