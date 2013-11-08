
#import "ShipFit.h"

// Compass Bearing
NSString *const N = @"N";
NSString *const NW = @"NW";
NSString *const W = @"W";
NSString *const SW = @"SW";
NSString *const S = @"S";
NSString *const SE = @"SE";
NSString *const E = @"E";
NSString *const NE = @"NE";
NSString *const ERROR = @"ERROR";


@implementation ShipFit



- (void)init_and_run_application
{
	
    Location *location = [ [Location alloc] initWithReference:self ];
    [location init_GPS];
    [location init_compass];
    [location runGPS_withAccuracy:100 andDistanceFilter:100]
    [location run_compass_withFilter: 1];
    
    
    
    
    
    
    
    
    
    
    
}








@end


// How and where do we want to store data
// What is the most efficient way that we can log the GPS...
// Hmm Ns.array class is way too much overhead.
// Structs !!?
// more ideas
//