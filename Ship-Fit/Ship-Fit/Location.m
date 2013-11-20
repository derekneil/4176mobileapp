#import "Location.h"
#import "ShipFit.h"

@implementation Location
{
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D *locationHead; //locations
    CLLocationCoordinate2D *locationBase;
    double *timeHead; //timestamps
    double *timeBase;
    NSTimer *_theTimer;
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
            timeHead = timeBase + 39999;
            locationHead = locationBase + 39999;
            

            // GIVE THE LIST TO THE MAP FOR ITS CONVENIENCE
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
        
        // Increment the counts. Two variables hopefully same value. 
        self.shipFit_ref.gps_count++; _count++;

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
    for(l = 0; l < 400000; l++, runner++, runner2++){
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
    if( self.GPS_MODE != SAILING_STARTUP)[self halt_GPS];
    
    NSLog(@"iOS 5 location event");
    
    /* Log the new lat and long values */
    [ self log_latitude:newLocation.coordinate.latitude
              longitude:newLocation.coordinate.longitude
              timestamp: [newLocation.timestamp timeIntervalSince1970 ] ];

    // UPDATE THE PROPERTIES
    [ self updateShipFitLocation: newLocation ];
    
    /* EVALUATE */
    [ self evaluate_GPS_MODE ];
}

// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if ( self.GPS_MODE != SAILING_STARTUP ) [self halt_GPS];
    
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

    [self updateShipFitLocation: [ locations lastObject ] ];

    //Evaluate the GPS MODE
    [ self evaluate_GPS_MODE ];
}



// UPDATE FRONT END PROPERTIES
- (void)updateShipFitLocation: (CLLocation*) current_location
{
    /* Make sure the update is relevant within 60 seconds */
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] - [current_location.timestamp timeIntervalSince1970 ] ) < 60 &&
        ( [current_location.timestamp timeIntervalSince1970 ] - _lastGPStimeInt) > 3 )
    {
        
        
        //save last time we updated the display property for GPS
        _lastGPStimeInt = [current_location.timestamp timeIntervalSince1970];
        
        // Set the new lat/lon
        self.shipFit_ref.latitude = current_location.coordinate.latitude;
        self.shipFit_ref.longitude = current_location.coordinate.longitude;
        
        // Let the SHIPFIT class know that the time stamp is valid.
        if(!self.GPSisValid && current_location.coordinate.latitude != 0 && current_location.coordinate.longitude != 0)self.GPSisValid = YES;
        NSLog( @"LAT: %f LONG: %f KNOTS:%f" , self.shipFit_ref.latitude , self.shipFit_ref.longitude , self.shipFit_ref.knots );
    }
    else
    {
        NSLog(@"not updating GPS display");
    }
    
    // Set the speed
    if ( current_location.speed != -1 )
    {
        self.shipFit_ref.knots = current_location.speed * 1.94384;
    }
    // mY speed function that still has some bugs
    //self.shipFit_ref.knots = [ self calculateSpeed: current_location ];
    
}


// CALCULATE 
// THE 
// SPEED 
// OF THE VESSEL
// USING A WEIGHTED AVERAGE BASED ON THE LAST 5 RELEVANT READINGS
// WORK IN PROGRESS
//- (double)calculateSpeed: (CLLocation*)current
//{
//    double speed = 0;
//
//    if ( _count > 5 )
//    {
//        CLLocation *location;
//        CLLocationCoordinate2D *locationRunner = locationHead + 1;
//        double *timeRunner = timeHead + 1;
//        double weight = 0.51612;
//
//        int i;
//        for (i = 0; i < 5; i++ , locationRunner++ , timeRunner++ )
//        {
//            double distance =  [current distanceFromLocation:[location initWithLatitude: (locationHead + i)->latitude
//                                                                              longitude: (locationHead + i)->longitude ] ];
//            speed += (weight) * ( distance / ( [current.timestamp timeIntervalSince1970] - *(timeRunner + i) ) );
//        }
//        weight /= 2;
//    }
//    return speed * 1.94384;
//}

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
    NSLog(@"%@", error);
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








