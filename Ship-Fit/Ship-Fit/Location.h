#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;


@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;
@property (nonatomic, readwrite, assign) BOOL logging_enabled;

- (id) initWithReference: (ShipFit *)reference;

- (void)init_logs_and_manager;

- (void)halt_GPS;

- (void)run_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                andDistanceFilter: (CLLocationDistance)distance;

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon;

- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations;


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

/* Errors */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end