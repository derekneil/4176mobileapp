#import "Location.h"
#import "ShipFit.h"

@implementation Location
{
    CLLocationCoordinate2D *_head;
    CLLocationCoordinate2D *_base;
    CLLocationManager *_locationManager;
    int _lastGPStimeInt;
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
    _locationManager = [ [CLLocationManager alloc] init ];
    _locationManager.delegate = self;
    _lastGPStimeInt = [[NSDate date] timeIntervalSince1970];
    
    if ( [CLLocationManager locationServicesEnabled] )
    {
        _base = (CLLocationCoordinate2D *)malloc( 20000 * sizeof(CLLocationCoordinate2D) );
        
        if ( _base == NULL ){
            NSLog(@"Call to heap failed");
            self.logging_enabled = NO;
        }
        else{
            self.logging_enabled = YES;
            _head = _base + 19999;
            ( _head + 1 )->latitude = 0;
            ( _head + 1 )->longitude = 0;
            self.shipFit_ref.gps_head = _head;
            self.shipFit_ref.gps_count = 0;
        }
    }
}

- (void)run_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                andDistanceFilter: (CLLocationDistance)distance
{
    if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied )
    {
        _locationManager.distanceFilter = distance;
        _locationManager.desiredAccuracy = accuracy;
        [ _locationManager startUpdatingLocation ];
    }
}


- (void)halt_GPS
{
    [ _locationManager stopUpdatingLocation ];
}

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon
{
    if ( self.logging_enabled )
    {
        if (self.shipFit_ref.gps_count == 0 ){
            _head->latitude = lat;
            _head->longitude = lon;
            self.shipFit_ref.gps_count++;
        }
        else if ( self.shipFit_ref.gps_count < 20000 )
        {
            _head--;
            _head->latitude = lat;
            _head->longitude = lon;
            self.shipFit_ref.gps_count++;
        }
        else if ( self.shipFit_ref.gps_count == 20000 )
        {
            // TO DO.
            // Do I store only 20,000 GPS OR Do I Malloc More Space
            // It is expensive to have to shift the elements each time
            // might be cheaper to malloc another array..
            // write the old one to the DB and then reallocate the space !!!
        }
    }
}

//for debug

- (void)print_logs_to_console
{
    CLLocationCoordinate2D *runner = _head;
    int i = 0;
    while ( i < self.shipFit_ref.gps_count )
    {
        NSLog(@"%f:%f", runner->latitude , runner->longitude );
        i++;
    }
}

// iOS 5 location manager delegate method
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"iOS 5 location event");
    
    [self updateShipFitLocation:newLocation];
    
    /* Log the new lat and long values */
    [ self log_latitude:newLocation.coordinate.latitude
              longitude:newLocation.coordinate.longitude ];
}

// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"iOS 6 location event");
    
    // Get the most recent. 
    CLLocation *current_location = [ locations lastObject ];
    [self updateShipFitLocation:current_location];
    
        
    /* Log each entry */
    int l;
    for (l = 0 ; l < [locations count] ; l++)
    {
        current_location = [locations objectAtIndex:l ];
        [self log_latitude:current_location.coordinate.latitude
                 longitude:current_location.coordinate.longitude ];
    }
    
}

//worker method to save duplicate code
- (void)updateShipFitLocation: (CLLocation*) current_location{
    /* Make sure the update is relevant within 60 seconds */
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 60 &&
        ( [current_location.timestamp timeIntervalSince1970 ] - _lastGPStimeInt) > 3)
    {
        //save last time we updated the display property for GPS
        _lastGPStimeInt = [current_location.timestamp timeIntervalSince1970];
        
        /* Set the new lat/long */
        self.shipFit_ref.latitude = current_location.coordinate.latitude;
        self.shipFit_ref.longitude = current_location.coordinate.longitude;
        
        /* Set the speed */
        self.shipFit_ref.knots = ( current_location.speed * 1.94384 );
        
        NSLog( @"LAT: %f LONG: %f KNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots);
    }
    
    else{
        NSLog(@"not updating GPS display");
    }
}

// Handling Authorization Status Changes.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"status: %d" , status );
    
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            break;
        case kCLAuthorizationStatusAuthorized:
            break;
    }
    
}

// Error Handling
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end




// head & tail
// head starts one ahead of tail
// if head catches up to tail you have to move tail
// to traverse all elements of the log you start from the tail and go to the head.
// once the array wraps around the valid entries range from the tail to the head
// to traverse: if the head == tail just start from head + 1 and go till you hit head again
// if head != tail. then go from tail + 1 to head - 1

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











