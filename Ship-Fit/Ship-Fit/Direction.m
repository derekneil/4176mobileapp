
#import "ShipFit.h"
#import "Direction.h"
#import "Location.h"

@implementation Direction
{
    CLLocationManager *_locationManager;
    NSMutableArray *compassLogs;
}


// This is the default class initializer.
// It is passed a reference from the shipFit class
// Initializes the CLLocationManager Object
// Initializes a mutable array for logging compass readings 
- (id) initWithReference: (ShipFit *)reference
{
    self = [super init];
    if ( self )
    {
        _shipFit_ref = reference;
        _locationManager = [ [CLLocationManager alloc] init ];
        _locationManager.delegate = self;
        compassLogs = [ [NSMutableArray alloc] init ];
    }
    return self;
}

// Delegate Method for Compass Events
// Make sure the time stamp is within the last 5 seconds
// Update display based on the mode of compass (true vs magnetic north)
// Log the compass reading
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@"%@", newHeading);
    if ( ( [ [ NSDate date ]  timeIntervalSince1970 ] -
          [newHeading.timestamp timeIntervalSince1970 ] ) < 5 )
    {
        if ( self.shipFit_ref.isTrueNorth ){
            self.shipFit_ref.compassDegrees = newHeading.trueHeading;
        }
        else{
            self.shipFit_ref.compassDegrees = newHeading.magneticHeading;
        }
        
        [ self set_bearing ];
        [self logHeading:newHeading];
        
        // see what we got
        [self print_logs_to_console];
    }
    else{
        NSLog(@"Time stamp for the compass is stale. Take the according action");
    }
}

// Run the compass with heading filter 5
- (void)run_compass
{
    if ( [ CLLocationManager headingAvailable ] ){
        _locationManager.headingFilter = 5;
        [ _locationManager startUpdatingHeading ];
    }
    else{
        NSLog(@"Compass Not Available");
    }
}

// Stop running the compass
- (void)halt_compass
{
    [ _locationManager stopUpdatingHeading ];
}



/*  Keeps a log of compass readings within the last two minutes. 
    Adds the element
    Removes elements that are older than 2 minutes
    Note: the elements are stored from oldest to youngest.
    If you hit an element that is valid you do not have to bother to check the rest. 
    */
- (void)logHeading: (CLHeading*)heading
{
    // Add the new entry
    [compassLogs addObject:heading];
    
    // Remove old entries
    CLHeading *info;
    int l = [compassLogs count],
    i = 0 , v = 1;
    while(v && (i < l))
    {
        info = [compassLogs objectAtIndex:0];
        if ( [heading.timestamp timeIntervalSince1970] - [info.timestamp timeIntervalSince1970] < 120){
            v = 0;
            continue;
        }
        else{
            [compassLogs removeObjectAtIndex:0];
            i++;
        }
    }
}

// Function to calculate if the vessel is travelling on a relatively straight path
// Calculates the std_deviation of all the compass readings within the last two minutes
// If the std_deviation is within X degrees then return YES!
- (BOOL)straight_travel
{
    unsigned short int X = 15;
    int l, o;
    double mean=0, std_deviation=0;
    CLHeading *runner;
    
    //calculate the mean of the compass readings
    l = [compassLogs count];
    for (o = 0; o < l; o++ )
    {
        runner = compassLogs[o];
        mean += runner.trueHeading;
    }
    mean = mean / l;
    
    //calculate the std_deviation
    for(o=0; o < l; o++)
    {
        runner = compassLogs[o];
        std_deviation += (runner.trueHeading - mean) * (runner.trueHeading - mean);
    }
    std_deviation = sqrt( (std_deviation/l) );
    
    NSLog(@"Std_Deviation: %f" , std_deviation);
    
    if ( std_deviation < X ){
        return YES;
    }
    else{
        return NO;
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

+ (NSString*)bearing_String:(double)deg
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

// Handling Authorization Status Changes.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Compass Services not determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Compass Services Restricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Compass Services Denied");
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"Compass Services Authorized");
            [self run_compass];
            break;
    }
}

- (void)print_logs_to_console
{
    int i;
    for (i = 0; i < [compassLogs count]; i++)
    {
        NSLog(@"%@",[compassLogs objectAtIndex:i]);
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog( @"COMPASS_ERROR\n%@" , error );
}

@end
