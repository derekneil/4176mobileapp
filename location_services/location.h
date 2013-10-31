#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipIt;

@interface location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) CLLocationManager *gps_manager;
@property (nonatomic, readwrite, strong) CLLocationManager *compass_manager;
@property (nonatomic, readwrite, strong) ShipIt *shipIt_ref;


- (id) initWithReference: (ShipIt *)reference;

- (short int)initialize_compass;

- (short int)initialize_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                       andDistanceFilter: (CLLocationDistance)distance;


// Delegate Location Manager Method
// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

// Delegate Location Manager Method
// iOS 5
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

// OTHER
- (void)set_bearing;


@end
