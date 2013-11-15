
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
    if( self.shipFit_ref.compassDegrees >= 337.5 || self.shipFit_ref.compassDegrees <= 22.5 )self.shipFit_ref.compassDirection = N;
    else if( self.shipFit_ref.compassDegrees > 22.5 && self.shipFit_ref.compassDegrees < 67.5 )self.shipFit_ref.compassDirection = NE;
    else if( self.shipFit_ref.compassDegrees >= 67.5 && self.shipFit_ref.compassDegrees <= 112.5 )self.shipFit_ref.compassDirection = E;
    else if( self.shipFit_ref.compassDegrees > 112.5 && self.shipFit_ref.compassDegrees < 157.5)self.shipFit_ref.compassDirection = SE;
    else if( self.shipFit_ref.compassDegrees >= 157.5 && self.shipFit_ref.compassDegrees <= 202.5)self.shipFit_ref.compassDirection = S;
    else if( self.shipFit_ref.compassDegrees > 202.5 && self.shipFit_ref.compassDegrees < 247.5 )self.shipFit_ref.compassDirection = SW;
    else if( self.shipFit_ref.compassDegrees >= 247.5 && self.shipFit_ref.compassDegrees <= 292.5)self.shipFit_ref.compassDirection = W;
    else if( self.shipFit_ref.compassDegrees > 292.5 && self.shipFit_ref.compassDegrees < 337.5)self.shipFit_ref.compassDirection = NW;
    else if ( self.shipFit_ref.compassDegrees == -1 )self.shipFit_ref.compassDirection = ERROR;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog( @"%@" , error );
}


@end
