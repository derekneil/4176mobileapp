#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipIt;

@interface location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) CLLocationManager *gps_manager;
@property (nonatomic, readwrite, strong) CLLocationManager *compass_manager;

@property (nonatomic, readwrite, strong) ShipIt *shipIt_ref;


// Initialization Method
- (void)init_gps_and_compass;

// Delegate Location Manager Method
// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

// Delegate Location Manager Method
// iOS 5
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

// OTHER
- (double)convert_to_knots: (double)meters_per_second;
- (void)set_bearing;


@end


// Make sure that 