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





@interface ShipIt : NSObject

// LOCATION PROPERTIES
// GPS
@property (nonatomic, readwrite, assign) CLLocationDegrees latitude;
@property (nonatomic, readwrite, assign) CLLocationDegrees longitude;
// COMPASS
@property (nonatomic, readwrite, assign) CLLocationDirection magnetic_north;
@property (nonatomic, readwrite, assign) CLLocationDirection true_north;
@property (nonatomic, readwrite, strong) NSString *magnetic_north_bearing;
@property (nonatomic, readwrite, strong) NSString *true_north_bearing;

@property (nonatomic, readwrite, assign) double knots;












@end
