#import "Location.h"
#import "ShipFit.h"

@implementation Location
{
    // OUR LOCATION MANAGER
    CLLocationManager *_locationManager;

    // STANDARD C ARRAY FOR STORING GPS COORDINATES
    // CLLOCATION2D for lat and long
    CLLocationCoordinate2D *locationHead; 
    CLLocationCoordinate2D *locationBase;
    
    // double for the time stamps
    // synchronized array to same indexes
    double *timeHead; 
    double *timeBase;

    // The Timer
    NSTimer *_theTimer;

    // Utility Variables
    BOOL _logging_enabled;
    int _count;
    int _lastGPStimeInt;
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


// Initialize Data Structures For GPS Logs 
- (void)init_GPSLOGS
{
    _locationManager = [ [CLLocationManager alloc] init ];
    _locationManager.delegate = self;
    _lastGPStimeInt = [ [ NSDate date ] timeIntervalSince1970 ];
    

    // DO WE HAVE PERMISSION TO ACCESS LOCATION SERVICES
    if (  [   CLLocationManager locationServicesEnabled  ] && 
        [ CLLocationManager authorizationStatus ] != kCLAuthorizationStatusDenied )
    {

        // HEAP TO STORE LOGS
        // 40000 GPS COORDINATES
        // DOUBLES FOR TIMESTAMPS
        // CLLOCATION FOR OUR COORDINATES
        if (
            (  ( timeBase = (double *)malloc( 40000 * sizeof(double) ) ) == NULL )
            ||
            ( ( locationBase = (CLLocationCoordinate2D *)malloc( 40000 * sizeof( CLLocationCoordinate2D ) ) ) == NULL )
            )
        {
            _logging_enabled = NO;
            // MEMORY CONSERVATION MODE?
        }
        else
        {
            _logging_enabled = YES;
            _count = 0;

            // Move the heads to the edge of memory farthest away from the base
            // Lets give ourselves a small amount of buffer space for errors
            timeHead = timeBase + 39900;
            locationHead = locationBase + 39900;
            //admin

            // GIVE THE POINTER TO THE HEAD OF THE ARRAY TO THE MAP FOR PATH TRACKING
            self.shipFit_ref.gps_head = locationHead;
            self.shipFit_ref.gps_count = 0;
        }
    }
}

- (void)run_GPS: (NSTimer *) timer
{
    NSLog(@"Running GPS");
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [ _locationManager startUpdatingLocation ];
}

- (void)halt_GPS
{
    NSLog(@"Halting GPS");
    [ _locationManager stopUpdatingLocation ];
}

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon
           timestamp: (double)timetime
{
    
    //SAVE THE POINT IN DYNAMIC MEMORY

    if ( _logging_enabled )
    {

        if ( _count == 0 )
        {
            *(timeHead) = timetime; 
            locationHead->latitude = lat;
            locationHead->longitude = lon;    
        }
        else
        {
            timeHead--;
            *(timeHead) = timetime;

            locationHead--;
            locationHead->latitude = lat;
            locationHead->longitude = lon;
        }
        
        // Increment the counts. Two variables hopefully same value.
        _count++;
        self.shipFit_ref.gps_count = _count;
        self.shipFit_ref.gps_head = locationHead;

    }

    // SAVE THE POINT TO THE DATABASE        
    NSString* datetime = [NSDateFormatter localizedStringFromDate:[NSDate date]
        dateStyle:NSDateFormatterShortStyle
        timeStyle:NSDateFormatterFullStyle];
    NSLog(@"Log to DB with tripID %d and datetime: %@",_shipFit_ref.tripID, datetime);
    
        //save point to database
    [_shipFit_ref.DB insertIntoGPS:_shipFit_ref.tripID
     lat:[NSString stringWithFormat:@"%.4f",lat ]
     lng:[NSString stringWithFormat:@"%.4f",lon ]
     dateandtime:datetime];
}

- (void)zero_logs
{
    int l;
    CLLocationCoordinate2D *runner = locationBase;
    double *runner2 = timeBase;
    for(l = 0; l < 39900; l++, runner++, runner2++){
        runner->latitude = 0;
        runner->longitude = 0;
        *runner2 = 0;
    }
}

//for debug
- (void)print_logs_to_console
{
    CLLocationCoordinate2D *runner = locationHead;
    int i;
    for ( i=0; i < self.shipFit_ref.gps_count; i++ , runner++ )
    {
        NSLog(@"%f:%f" , runner->latitude , runner->longitude );
    }
}

// 
// HANDLE
// EVeNTS
// LOCATION 
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation


{
    if( self.GPS_MODE != SAILING_STARTUP){
        [self halt_GPS];
    }

    /* Log the new lat and long values */
    [ self log_latitude:newLocation.coordinate.latitude
              longitude:newLocation.coordinate.longitude
              timestamp: [newLocation.timestamp timeIntervalSince1970 ] ];

    // UPDATE THE DISPLAY
    [ self updateShipFitLocation:newLocation ];
    
    // EVALUATE
    [ self evaluate_GPS_MODE ];
    NSLog(@"iOS 5 location event");
}

// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (self.GPS_MODE != SAILING_STARTUP)\
    {
        [self halt_GPS];  
    } 

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

    // UPDATE THE DISPLAY
    [self updateShipFitLocation: [ locations lastObject ] ];

    //Evaluate the GPS MODE
    [ self evaluate_GPS_MODE ];
    NSLog(@"iOS 6 location event");
}



// UPDATE FRONT END PROPERTIES
- (void)updateShipFitLocation: (CLLocation*) current_location
{
     // Set the speed
    if ( _count > 5 && ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 3 ) )    
    {
        self.shipFit_ref.knots = [ self calculateSpeed];
        //self.shipFit_ref.knots = current_location.speed * 1.94384;
    }

    // Set the latitude and longitude 
        if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 60 &&
        ( [current_location.timestamp timeIntervalSince1970 ] - _lastGPStimeInt) > 3 ){

        //save last time we updated the display property for GPS
        _lastGPStimeInt = [current_location.timestamp timeIntervalSince1970];
        
        // update the lat/long display
        self.shipFit_ref.latitude = current_location.coordinate.latitude;
        self.shipFit_ref.longitude = current_location.coordinate.longitude;
        
        NSLog( @"LAT: %f LONG: %f KNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots );
    }
    else{
        NSLog(@"not updating GPS display");
    }

    // FLIP THE WEATHER SWITCH
    if( !self.GPSisValid )
    {
        self.GPSisValid = YES;
    }
}


// CALCULATE 
// THE 
// SPEED 
// OF THE VESSEL
// USING A WEIGHTED AVERAGE BASED ON THE LAST 5 RELEVANT READINGS
// WORK IN PROGRESS
- (double)calculateSpeed
{
    CLLocationCoordinate2D *locationRunner = locationHead + 1;
    double  speed = 0, 
            *timeRunner = timeHead + 1,
            weight = 0.51612;
    int i;

    for (i = 0; i < 5; i++ , locationRunner++ , timeRunner++ )
    {
        double distance = [self haversine_km_withLat1:locationHead->latitude Lon1:locationHead->longitude Lat2:locationRunner->latitude Lon2:locationRunner->longitude];
        double elapsed_time = *timeHead - *timeRunner;
        double velocity = distance / elapsed_time;

        if ( velocity < 0 ){
            velocity *= -1;
        }

        speed += (weight)*(velocity);
    }
    return speed * 1.94384;
}

- (double) haversine_km_withLat1: (double) lat1 Lon1: (double) lon1 Lat2: (double) lat2 Lon2: (double) lon1
{
    double R = 6371;
    double RAD = (M_PI * 180.0 );
    double dlon = (lon1 - lon2) * RAD;  // convert from degrees to radians
    double dlat = (lat1 - lat2 ) * RAD; // convert from degrees to radian
    double a = pow(sin(dlat/2.0) , 2) * cos(lat1*RAD) * cos(lat2*RAD) * pow(sin(dlon/2.0),2);
    double c = 2 * atan( sqrt(a), sqrt(1-a) );
    return c * R;
}

- (void)evaluate_GPS_MODE
{

    int l, o;
    
    switch (self.GPS_MODE)
    {
        case SAILING_STARTUP:
            NSLog(@"GPS MODE: STARTUP");
            // If you have less than 10 gps locations stay in start up
            if (self.shipFit_ref.gps_count < 10)
            {
                break;
            }

            // If you have more, check to see if the last 10 location updates are within the last 5 minutes
            else
            {
                double *runner = timeHead;
                for( l=0, o=1 ; l<10 ; l++ ,runner++ ){
                    if( ( [ [ NSDate date ]  timeIntervalSince1970 ] - *runner ) > 300 ){
                        o = 0;
                        break;
                    }
                }

                // SAILING_STARTUP TO SAILING_ROUGH TRANSITION
                if (o){
                    self.GPS_MODE = SAILING_ROUGH;
                }
                break;
            }

        case SAILING_ROUGH:
            NSLog(@"GPS MODE: ROUGH");
            _theTimer = [NSTimer scheduledTimerWithTimeInterval:15
                                                         target:self
                                                       selector:@selector(run_GPS:)
                                                       userInfo:nil
                                                        repeats:NO ];
            break;
            
        case SAILING_SMOOTH:
            NSLog(@"GPS MODE: SMOOTH");
            _theTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                         target:self
                                                       selector:@selector(run_GPS:)
                                                       userInfo:nil
                                                        repeats:NO ];
            break;
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
            [self release_memory];
            NSLog(@"Location Services Denied");
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
    NSLog(@"GPS ERROR:%@", error);
}

- (void)release_memory
{
    free(locationBase);
    free(timeBase);
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








