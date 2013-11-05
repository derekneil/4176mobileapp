#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;
@class MKMapView;

@interface location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipIt_ref;
@property (nonatomic, readwrite, strong) CLLocationManager *gps_manager;
@property (nonatomic, readwrite, strong) CLLocationManager *compass_manager;


/* Function Declarations */
- (id) initWith_Reference: (ShipFit *)reference;

- (short int)run_compass;

- (short int)run_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                andDistanceFilter: (CLLocationDistance)distance;

- (void)halt_GPS;
- (short int)log_GPS;
- (void)halt_compass;

// Delegate Location Manager Method
// iOS 6 & 7
- (void)locationManager: (CLLocationManager *)manager 
     didUpdateLocations: (NSArray *)locations;

// Delegate Location Manager Method
// iOS 5
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)set_bearing;

@end


