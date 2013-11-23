#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DatabaseAccess.h"

//Compass Macros
extern NSString *const N;
extern NSString *const NW;
extern NSString *const W;
extern NSString *const SW;
extern NSString *const S;
extern NSString *const SE;
extern NSString *const E;
extern NSString *const NE;
extern NSString *const ERROR;

@interface ShipFit : NSObject

// For DATABASE
@property ( nonatomic, readonly, strong) DatabaseAccess* DB;
@property (nonatomic, readwrite, assign) int tripID;

// For remote tracking
@property ( nonatomic, readwrite, assign ) CLLocationCoordinate2D *gps_head;
@property ( nonatomic, readwrite, assign ) NSUInteger gps_count;

//Properties for the UI to Observe
@property (nonatomic, readwrite, assign) CLLocationDegrees latitude;
@property (nonatomic, readwrite, assign) CLLocationDegrees longitude;
@property (nonatomic, readwrite, assign) BOOL isTrueNorth;
@property (nonatomic, readwrite, assign) CLLocationDirection compassDegrees;
@property (nonatomic, readwrite, strong) NSString *compassDirection;
@property (nonatomic, readwrite, assign) double knots;
@property (nonatomic, readwrite, strong) NSDictionary* weatherJSON;

/* Functions */
- (void)init_and_run_application;
- (unsigned short int)get_gps_mode;
- (BOOL)currently_sailing_straight;
+ (void)setApplicationDefaults;
+ (void)setUpObservers;
+ (short int)inandr_compass_and_gps
+ (short int)inandr_Database
+ (short int)inandr_weather

@end
