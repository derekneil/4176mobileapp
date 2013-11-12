#import "Location.h"
#import "ShipFit.h"

@implementation Location
{
    CLLocationCoordinate2D *_head;
    CLLocationCoordinate2D *_tail;
    CLLocationCoordinate2D *_base;
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
    _locationManager = [ [CLLocationManager alloc] init ];
    _locationManager.delegate = self;
    
    if ( [CLLocationManager locationServicesEnabled] )
    {
        /* Make the call to the HEAP */
        _base = (CLLocationCoordinate2D *)malloc( 20000 * sizeof(CLLocationCoordinate2D) );
        
        if ( _base == NULL ){
            NSLog(@"Call to heap failed");
        }
        else{
            _tail = _base;
            _head = _base + 1;
        }
    }
}

- (void)run_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                andDistanceFilter: (CLLocationDistance)distance
{
    printf("%d\n", [CLLocationManager authorizationStatus] );
    
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
    /* Update the tail pointer */
    if ( _head == _tail ) 
    {
        if( _tail == (_base + 20000) ){
            _tail = _base;
        }
        else{
            _tail++;
        }
    }

    /* Add the new entry */
    _head->latitude = lat;
    _head->longitude = lon;

    /* Update the head pointer */
    if( _head == (_base + 20000) ){
        _head = _base;
    }
    else{
        _head++;
    }
}

// iOS 5 location manager delegate method
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"iOS 5 location event");
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

        NSLog( @"LAT: %f\nLONG: %f\nKNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots);
    }
    else{
        NSLog(@"Entry is over 1 minute old.....");
    }
}

// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"iOS 6 location event");
    
    // Get the most recent. 
    CLLocation *current_location = [ locations lastObject ];
    
    /* Make sure the update is relevant within 60 seconds */
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 60 )
    {
        /* Set the new lat/long */
        self.shipFit_ref.latitude = current_location.coordinate.latitude;
        self.shipFit_ref.longitude = current_location.coordinate.longitude;
            
        /* Set the speed */
        self.shipFit_ref.knots = ( current_location.speed * 1.94384 );
            
        NSLog( @"LAT: %f\nLONG: %f\nKNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots);
    }
    
    else{
        NSLog(@"Entry is over 1 minute old......");
    }
        
    /* Log each entry */
    int l;
    for (l = 0 ; l < [locations count] ; l++)
    {
        current_location = [locations objectAtIndex:l ];
        [self log_latitude:current_location.coordinate.latitude
                    longitude:current_location.coordinate.longitude ];
    }
    
}

// Authorization Status Changes.
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











