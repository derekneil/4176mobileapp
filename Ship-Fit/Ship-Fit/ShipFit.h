#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

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
//@property (nonatomic, readwrite, assign) MKMapView *map_view_ref;



// For remote tracking
@property ( nonatomic, readwrite, assign ) CLLocationCoordinate2D *head;
@property ( nonatomic, readwrite, assign ) int count;


/*
 Properties for the UI to Observe..... Do with them what you please. 
 */
@property (nonatomic, readwrite, assign) CLLocationDegrees latitude;
@property (nonatomic, readwrite, assign) CLLocationDegrees longitude;
@property (nonatomic, readwrite, assign) BOOL isTrueNorth;
@property (nonatomic, readwrite, assign) CLLocationDirection compassDegrees;
@property (nonatomic, readwrite, strong) NSString *compassDirection;
@property (nonatomic, readwrite, assign) double knots;



/* Functions */
- (void)init_and_run_application;

@end
