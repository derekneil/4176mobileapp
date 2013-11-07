#import "Location.h"
#import "ShipFit.h"

@implementation Location

// Error Handling
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
#if 1
    NSLog(@"%@", error);
#endif
    
    
    
    if ( manager == self.gps_manager )
    {
        //
    }
    
    if ( manager == self.compass_manager )
    {
        //
    }
    
    
}



- (unsigned short int)init_GPS
{
    short int returncode;
    
    switch ([CLLocationManager authorizationStatus])
    {
        case 0:
            returncode = kCLAuthorizationStatusNotDetermined;
            break;
        case 1:
            returncode = kCLAuthorizationStatusRestricted;
            break;
        case 2:
            returncode = kCLAuthorizationStatusDenied;
            break;
        case 3:
            returncode = kCLAuthorizationStatusAuthorized;
            break;
    }
    
    if ( returncode == kCLAuthorizationStatusAuthorized )
    {
        self.gps_manager = [ [CLLocationManager alloc] init];
        self.gps_manager.delegate = self;
    }
    
    return returncode;
}

- (short int)run_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                andDistanceFilter: (CLLocationDistance)distance
{
    short int returncode;
    if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized )
    {
        self.gps_manager.distanceFilter = distance;
        self.gps_manager.desiredAccuracy = accuracy;
        [ self.gps_manager startUpdatingLocation ];
        returncode = 1;
    }
    else
    {
        returncode = -1;
    }
    return returncode;
}


- (void)halt_GPS
{
    [ self.gps_manager stopUpdatingLocation ];
}

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon
{
    // to do
}

// iOS 5 location manager delegate method
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    // GPS MANAGER
    if ( manager == self.gps_manager )
    {
        
        /* Make sure the time stamp is relevant */
        if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [newLocation.timestamp timeIntervalSince1970 ] ) < 60 )
        {
            /* Set the new lat and long values */
            self.shipFit_ref.latitude = newLocation.coordinate.latitude;
            self.shipFit_ref.longitude = newLocation.coordinate.longitude;
            
            /* Log the new lat and long values */
            [ self log_latitude:newLocation.coordinate.latitude
                      longitude:newLocation.coordinate.longitude ];
            
            /* Set the new speed property */
            self.shipFit_ref.knots = ( (newLocation.speed) * 1.94384 );
#if 1
            NSLog( @"LAT: %f\nLONG: %f\nKNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots);
#endif
        }
        else
        {
#if 1
            NSLog(@"Entry is over 1 minute old.....");
#endif
        }
    }
}

// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    unsigned short int l;
    
    if ( manager == self.gps_manager )
    {
        // Update the location
        CLLocation *current_location = [ locations lastObject ];
        if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 60 )
        {
            /* Set the new lat/long */
            self.shipFit_ref.latitude = current_location.coordinate.latitude;
            self.shipFit_ref.longitude = current_location.coordinate.longitude;
            
            /* Set the speed */
            self.shipFit_ref.knots = ( current_location.speed * 1.94384 );
#if 1
            NSLog( @"LAT: %f\nLONG: %f\nKNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots);
#endif
        }
        else
        {
#if 1
            NSLog(@"Entry is over 1 minute old......");
#endif
        }
        
        
        for (l = 0 ; l < [locations count] ; l++)
        {
            current_location = [locations objectAtIndex:l ];
            [self log_latitude:current_location.coordinate.latitude
                     longitude:current_location.coordinate.longitude ];
        }
        
    }
    
    
    
    
}


- (BOOL)init_compass
{
    if ( [ CLLocationManager headingAvailable ] )
    {
        self.compass_manager =  [ [CLLocationManager alloc] init ];
        self.compass_manager.delegate = self;
        return YES;
    }
    else
    {
        return NO;
    }
}


// Returns
// 1 on success
// -1 on failure
- (BOOL)run_compass_withFilter: (CLLocationDegrees)compass_accuracy
{
    if ( [ CLLocationManager headingAvailable ] )
    {
        self.compass_manager.headingFilter = compass_accuracy;
        [ self.compass_manager startUpdatingHeading ];
        return YES;
    }
    else
    {
#if 1
        NSLog(@"Compass Not Available");
#endif
        return NO;
    }
}

- (void)halt_compass
{
    [ self.compass_manager stopUpdatingHeading ];
}

// Delegate Method for Compass Events
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    if ( self.compass_manager == manager && [CLLocationManager headingAvailable] )
    {
        if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [newHeading.timestamp timeIntervalSince1970 ] ) < 5 )
        {
            self.shipFit_ref.magnetic_north = newHeading.magneticHeading;
            self.shipFit_ref.true_north = newHeading.trueHeading;
            [ self set_bearing ];
        }
        else
        {
            NSLog(@"Time stamp for the compass is stale. Take the according action");
        }
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


- (id) initWithReference: (ShipFit *)reference
{
    self = [super init];
    if ( self ){
        _shipFit_ref = reference;
    }
    return self;
}

@end


// Initiazes a gps_manager with the accuracy and distance setting.
// Controlling these settings is at the whim of the ShipFit.h class
// Which contains the majority of functions that we need.
// RETURNS -1 Location Services Not Available 0 Location Services Not Determined Yet
// 1 If the GPS is Authorized and Running (ONE IS GOOD) (NEGATIVE ONE BAD)
// When the location manager calls this method an error was encountered
// when trying to get the location or heading data. If the service was
// unable to get a location error right away it reports a kCLErrorLocationUnkown
// error and keeps trying. This can be ingnored. However, a kCLErrorDenied is
// received if the User denies LS. A kCLErrorHeadingFailure is due to interference.

// log each element in the array.
// maybe have to do some checking on the size of the logs
// also what is the most efficient way that we can
// how many reading do you think we need.
// how many does derek need to draw his line?
// it should be as spread out as possible.
// don't ya think!!