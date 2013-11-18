#import "Location.h"
#import "ShipFit.h"

@implementation Location
{
    CLLocationManager *_locationManager;
    
    CLLocationCoordinate2D *_locationsHead; //locations
    CLLocationCoordinate2D *_locationsBase;
    double *_timesHead; //timestamps
    double *_timesBase;
    
    int _lastGPStimeInt;
    NSTimer *_theTimer;
}

- (id) initWithReference: (ShipFit *)reference
{
    self = [super init];
    if ( self ){
        _shipFit_ref = reference;
        _GPSisValid = NO;
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
        _locationsBase = (CLLocationCoordinate2D *)malloc( 20000 * sizeof(CLLocationCoordinate2D) );
        _timesBase = (double *)malloc( 20000 * sizeof(double));
        
        if ( _timesBase == NULL || _locationsBase == NULL ){
            NSLog(@"Logging not enabled.");
            self.logging_enabled = NO;
        }
        else
        {
            self.logging_enabled = YES;
            _timesHead = _timesBase + 20000;
            _locationsHead = _locationsBase + 20000;
            
            self.shipFit_ref.gps_head = _locationsHead;
            self.shipFit_ref.gps_count = 0;
        }
    }
}

- (void)run_GPS:(NSTimer *)timer
{
    NSLog(@"Running GPS");
    if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied )
    {
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [ _locationManager startUpdatingLocation ];
    }
}

- (void)halt_GPS
{
    NSLog(@"Halting GPS");
    [ _locationManager stopUpdatingLocation ];
}

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon
           timestamp: (double)time
{
    if ( self.logging_enabled ){
        
        NSString* datetime = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterFullStyle];
        NSLog(@"Log to DB with tripID %d and datetime: %@",_shipFit_ref.tripID, datetime);
    
        //save point to database
        [_shipFit_ref.DB insertIntoGPS:_shipFit_ref.tripID
                                   lat:[NSString stringWithFormat:@"%.4f",lat ]
                                   lng:[NSString stringWithFormat:@"%.4f",lon ]
                           dateandtime:datetime];
        
        // Heap Storage.
        if (self.shipFit_ref.gps_count == 0 ){
            _locationsHead->latitude = lat;
            _locationsHead->longitude = lon;
            *_timesHead = time;
            self.shipFit_ref.gps_count++;
        }
        else if ( self.shipFit_ref.gps_count < 20000 )
        {
            _locationsHead--; _timesHead--;
            _locationsHead->latitude = lat;
            _locationsHead->longitude = lon;
            *_timesHead = time;
            self.shipFit_ref.gps_count++;
        }
        else if ( self.shipFit_ref.gps_count == 20000 )
        {
            // TO DO.
        }
    }
    else{
        NSLog(@"Logging not enabled");
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
              longitude:newLocation.coordinate.longitude
              timestamp:[newLocation.timestamp timeIntervalSince1970 ] ];
    
    [ self evaluate_GPS_MODE ];
}

// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"iOS 6 location event");
    
    // Log each entry
    CLLocation *current_location;
    int l;
    for (l = 0 ; l < [locations count] ; l++)
    {
        current_location = [locations objectAtIndex:l ];
        [self log_latitude:current_location.coordinate.latitude
                 longitude:current_location.coordinate.longitude
                 timestamp:[current_location.timestamp timeIntervalSince1970 ] ];
    }
    
    current_location = [ locations lastObject ];
    [self updateShipFitLocation:current_location];
}

- (void)updateShipFitLocation: (CLLocation*) current_location{
    
    /* Make sure the update is relevant within 60 seconds */
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 60 &&
        ( [current_location.timestamp timeIntervalSince1970 ] - _lastGPStimeInt) > 3)
    {
        //save last time we updated the display property for GPS
        _lastGPStimeInt = [current_location.timestamp timeIntervalSince1970];
        
        // Set the new lat/lon
        self.shipFit_ref.latitude = current_location.coordinate.latitude;
        self.shipFit_ref.longitude = current_location.coordinate.longitude;
        if(!self.GPSisValid)self.GPSisValid = YES;
        
        // Calculate the current speed 
        [ self calculateSpeed:current_location ];
        
        NSLog( @"LAT: %f LONG: %f KNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots);
    }
    else{
        NSLog(@"not updating GPS display");
    }
    
    //Evaluate the GPS MODE
    [ self evaluate_GPS_MODE ];
}

- (void)calculateSpeed: (CLLocation*)current
{
    CLLocation *location = [[ CLLocation alloc] initWithLatitude:(_locationsHead + 1)->latitude
                                                       longitude:(_locationsHead + 1)->longitude ];
    switch (self.GPS_MODE)
    {
        case SAILING_STARTUP:
            self.shipFit_ref.knots = 0;
            break;
        case SAILING_ROUGH:
            self.shipFit_ref.knots = ( (
                                        ( [current distanceFromLocation:location] ) / ( *_timesHead - *(_timesHead + 1) )
                                        ) * 1.94384 );
            break;
        case SAILING_SMOOTH:
            // to do
            break;
    }
}

- (void)evaluate_GPS_MODE
{
    int l, o;
    
    switch (self.GPS_MODE)
    {
        case SAILING_STARTUP:
            if (self.shipFit_ref.gps_count < 10){
                break;
            }
            else{
                double *runner = _timesHead;
                for( l=0, o=1 ; l<10 ; l++ ,runner++ ){
                    if( ( [ [ NSDate date ]  timeIntervalSince1970 ] - *runner ) > 30 ){
                        o = 0;
                        break;
                    }
                }
                if (o){
                    self.GPS_MODE = SAILING_ROUGH;
                    [self halt_GPS];
                }
                break;
            }
    
        case SAILING_ROUGH:
            NSLog(@"rough sailing");
            [self halt_GPS];
            break;
            
        case SAILING_SMOOTH:
            NSLog(@"smooth sailing");
            [self halt_GPS];
            break;
    }
    
    // Set Timer
    if ( self.GPS_MODE == SAILING_ROUGH )
    {
        _theTimer = [NSTimer scheduledTimerWithTimeInterval:15
                                                     target:self
                                                   selector:@selector(run_GPS:)
                                                   userInfo:nil
                                                    repeats:NO ];
    }
}

// Handling Authorization Status Changes.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Location Services not determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Location Services Restricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Location Services Denied");
            [self halt_GPS];
            //pop up?
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"Location Services Authorized");
            [self run_GPS:nil];
            break;
    }
}

// Error Handling
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)flushlogs
{
    int l;
    CLLocationCoordinate2D *runner = _locationsBase;
    for(l = 0; l < 200000; l++, runner++){
        runner->latitude = 0;
        runner->longitude = 0;
    }
}

//for debug
- (void)print_logs_to_console
{
    CLLocationCoordinate2D *runner = _locationsHead;
    int i;
    for ( i=0; i < self.shipFit_ref.gps_count; i++ , runner++ )
    {
        NSLog(@"%f:%f" , runner->latitude , runner->longitude );
    }
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

// Do I store only 20,000 GPS OR Do I Malloc More Space
// It is expensive to have to shift the elements each time
// might be cheaper to malloc another array..
// write the old one to the DB and then reallocate the space !!!

// flush logs...
// what if we are in Ecuador !!!?








