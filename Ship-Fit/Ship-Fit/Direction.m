
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
    _locationManager = [[CLLocationManager alloc] init ];
    _locationManager.delegate = self;
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
    NSLog(@"Compass!!\n%@\n", newHeading);
    
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [newHeading.timestamp timeIntervalSince1970 ] ) < 60 )
    {
        self.shipFit_ref.magnetic_north = newHeading.magneticHeading;
        self.shipFit_ref.true_north = newHeading.trueHeading;
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
    if( self.shipFit_ref.true_north >= 337.5 || self.shipFit_ref.true_north <= 22.5 )self.shipFit_ref.true_north_bearing = N;
    else if( self.shipFit_ref.true_north > 22.5 && self.shipFit_ref.true_north < 67.5 )self.shipFit_ref.true_north_bearing = NE;
    else if( self.shipFit_ref.true_north >= 67.5 && self.shipFit_ref.true_north <= 112.5 )self.shipFit_ref.true_north_bearing = E;
    else if( self.shipFit_ref.true_north > 112.5 && self.shipFit_ref.true_north < 157.5)self.shipFit_ref.true_north_bearing = SE;
    else if( self.shipFit_ref.true_north >= 157.5 && self.shipFit_ref.true_north <= 202.5)self.shipFit_ref.true_north_bearing = S;
    else if( self.shipFit_ref.true_north > 202.5 && self.shipFit_ref.true_north < 247.5 )self.shipFit_ref.true_north_bearing = SW;
    else if( self.shipFit_ref.true_north >= 247.5 && self.shipFit_ref.true_north <= 292.5)self.shipFit_ref.true_north_bearing = W;
    else if( self.shipFit_ref.true_north > 292.5 && self.shipFit_ref.true_north < 337.5)self.shipFit_ref.true_north_bearing = NW;
    else if ( self.shipFit_ref.true_north == -1 )self.shipFit_ref.true_north_bearing = ERROR;
    
    if( self.shipFit_ref.magnetic_north >= 337.5 || self.shipFit_ref.magnetic_north <= 22.5 )self.shipFit_ref.magnetic_north_bearing = N;
    else if( self.shipFit_ref.magnetic_north > 22.5 && self.shipFit_ref.magnetic_north < 67.5 )self.shipFit_ref.magnetic_north_bearing = NE;
    else if( self.shipFit_ref.magnetic_north >= 67.5 && self.shipFit_ref.magnetic_north <= 112.5 )self.shipFit_ref.magnetic_north_bearing = E;
    else if( self.shipFit_ref.magnetic_north > 112.5 && self.shipFit_ref.magnetic_north < 157.5)self.shipFit_ref.magnetic_north_bearing = SE;
    else if( self.shipFit_ref.magnetic_north >= 157.5 && self.shipFit_ref.magnetic_north <= 202.5)self.shipFit_ref.magnetic_north_bearing = S;
    else if( self.shipFit_ref.magnetic_north > 202.5 && self.shipFit_ref.magnetic_north < 247.5 )self.shipFit_ref.magnetic_north_bearing = SW;
    else if( self.shipFit_ref.magnetic_north >= 247.5 && self.shipFit_ref.magnetic_north <= 292.5)self.shipFit_ref.magnetic_north_bearing = W;
    else if( self.shipFit_ref.magnetic_north > 292.5 && self.shipFit_ref.magnetic_north < 337.5)self.shipFit_ref.magnetic_north_bearing = NW;
    else if ( self.shipFit_ref.magnetic_north == -1 )self.shipFit_ref.magnetic_north_bearing = ERROR;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    // to do
}


@end
