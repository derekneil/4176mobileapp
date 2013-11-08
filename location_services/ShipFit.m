
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

// Shared Logic Between the UI and the back-end. 
// Lets try and keep this code very concise

@implementation ShipFit

// What type of return do you want?
// We will start with a simple integer

- (unsigned short int)initialize_modules
{
	unsigned short int returncode;

	// Init location modules
}








@end


// How and where do we want to store data
// What is the most efficient way that we can log the GPS...
// Hmm Ns.array class is way too much overhead. 
// Structs !!?