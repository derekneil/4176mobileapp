#import "location.h"
#import "ShipIt.h"

@implementation location

// Custom initializer
- (id) initWithReference: (ShipIt *)reference{
    self = [super init];
    if (self){
        _shipIt_ref = reference;
    }
    return self;
}

// RETURNS
// -1 Location Services Not Available
// 0 Location Services Not Determined Yet
// 1 If the GPS is Authorized and Running
- (short int)initialize_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                          andDistanceFilter: (CLLocationDistance)distance {
    
    short int returncode = 0;
    
    // IF the user or application is not permitted to access the device's location.
    if ( ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ) ||
        ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ) )
    {
        returncode = -1;
    }
    
    // The application has full permission to access the location services
    if (  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ){
        self.gps_manager = [ [CLLocationManager alloc] init ];
        self.gps_manager.delegate = self;
        self.gps_manager.distanceFilter = distance;
        self.gps_manager.desiredAccuracy = accuracy;
        returncode = 1;
    }
    
    // Start Getting the Data
    if( returncode > 0){
        [ self.gps_manager startUpdatingLocation ];
    }
    
    return returncode;
}


// Returns
// 1 on success
// -1 on failure
- (short int)initialize_compass
{
    short int returncode;
    
    if( [ CLLocationManager headingAvailable ] ){
        self.compass_manager = [ [CLLocationManager alloc] init ];
        [ self.compass_manager startUpdatingHeading ];
        returncode = 1;
    }
    else{
        returncode = -1;
    }
    
    return returncode;
}

#if 0
// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = locations[0];
    
    // Get the latitude and longitude 
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    NSLog(@"LAT: %f\nLONG: %f" , self.latitude, self.longitude );
    
    // Get the speed in Knots
    self.speed_in_knots = [ self convert_to_knots:location.speed ];
    
    // Get the direction
    // Set the bearing based on the description
    self.direction = location.course;
    [ self set_bearing ];
    
}
#endif

// iOS 5
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    // GPS MANAGER
    if ( manager == self.gps_manager ){
        self.shipIt_ref.latitude = newLocation.coordinate.latitude;
        self.shipIt_ref.longitude = newLocation.coordinate.longitude;
        NSLog( @"LAT: %f\nLONG: %f" , self.shipIt_ref.latitude, self.shipIt_ref.longitude );
    }
    
    
    // Get the speed in knots
    self.speed_in_knots = [ self convert_to_knots:newLocation.speed ];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if ( self.compass_manager == manager ){
        
        // Make sure the time stamp is relevant
        if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [newHeading.timestamp timeIntervalSince1970 ] ) < 5 ){
            self.shipIt_ref.magnetic_north = newHeading.magneticHeading;
            self.shipIt_ref.true_north = newHeading.trueHeading;
        }
        else{
            // to do
        }
    }
}





- (double)convert_to_knots: (double)meters_per_second{
    return ( (1.94384) * meters_per_second );
}

// Sets the bearing based on the readings for magnetic and true north
- (void)set_bearing
{
    if( self.shipIt_ref.true_north >= 337.5 || self.shipIt_ref.true_north <= 22.5 )self.shipIt_ref.true_north_bearing = N;
    else if( self.shipIt_ref.true_north > 22.5 && self.shipIt_ref.true_north < 67.5 )self.shipIt_ref.true_north_bearing = NE;
    else if( self.shipIt_ref.true_north >= 67.5 && self.shipIt_ref.true_north <= 112.5 )self.shipIt_ref.true_north_bearing = E;
    else if( self.shipIt_ref.true_north > 112.5 && self.shipIt_ref.true_north < 157.5)self.shipIt_ref.true_north_bearing = SE;
    else if( self.shipIt_ref.true_north >= 157.5 && self.shipIt_ref.true_north <= 202.5)self.shipIt_ref.true_north_bearing = S;
    else if( self.shipIt_ref.true_north > 202.5 && self.shipIt_ref.true_north < 247.5 )self.shipIt_ref.true_north_bearing = SW;
    else if( self.shipIt_ref.true_north >= 247.5 && self.shipIt_ref.true_north <= 292.5)self.shipIt_ref.true_north_bearing = W;
    else if( self.shipIt_ref.true_north > 292.5 && self.shipIt_ref.true_north < 337.5)self.shipIt_ref.true_north_bearing = NW;
    else if ( self.shipIt_ref.true_north == -1 )self.shipIt_ref.true_north_bearing = ERROR;
    if( self.shipIt_ref.magnetic_north >= 337.5 || self.shipIt_ref.magnetic_north <= 22.5 )self.shipIt_ref.magnetic_north_bearing = N;
    else if( self.shipIt_ref.magnetic_north > 22.5 && self.shipIt_ref.magnetic_north < 67.5 )self.shipIt_ref.magnetic_north_bearing = NE;
    else if( self.shipIt_ref.magnetic_north >= 67.5 && self.shipIt_ref.magnetic_north <= 112.5 )self.shipIt_ref.magnetic_north_bearing = E;
    else if( self.shipIt_ref.magnetic_north > 112.5 && self.shipIt_ref.magnetic_north < 157.5)self.shipIt_ref.magnetic_north_bearing = SE;
    else if( self.shipIt_ref.magnetic_north >= 157.5 && self.shipIt_ref.magnetic_north <= 202.5)self.shipIt_ref.magnetic_north_bearing = S;
    else if( self.shipIt_ref.magnetic_north > 202.5 && self.shipIt_ref.magnetic_north < 247.5 )self.shipIt_ref.magnetic_north_bearing = SW;
    else if( self.shipIt_ref.magnetic_north >= 247.5 && self.shipIt_ref.magnetic_north <= 292.5)self.shipIt_ref.magnetic_north_bearing = W;
    else if( self.shipIt_ref.magnetic_north > 292.5 && self.shipIt_ref.magnetic_north < 337.5)self.shipIt_ref.magnetic_north_bearing = NW;
    else if ( self.shipIt_ref.magnetic_north == -1 )self.shipIt_ref.magnetic_north_bearing = ERROR;
}


// When the location manager calls this method an error was encountered
// when trying to get the location or heading data. If the service was
// unable to get a location error right away it reports a kCLErrorLocationUnkown
// error and keeps trying. This can be ingnored. However, a kCLErrorDenied is
// received if the User denies LS. A kCLErrorHeadingFailure is due to interference.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // to do
}

@end