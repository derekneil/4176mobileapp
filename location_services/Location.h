#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;
@property (nonatomic, readwrite, strong) CLLocationManager *gps_manager;
@property (nonatomic, readwrite, strong) CLLocationManager *compass_manager;


/* Function Declarations */
- (id) initWith_Reference: (ShipFit *)reference;



- (BOOL)init_compass;
- (BOOL)run_compass_withFilter: (CLLocationDegrees)compass_accuracy;
- (void)halt_compass;
- (void)set_bearing;



// GPS
- (unsigned short int)init_GPS;
- (void)halt_GPS;

- (short int)run_GPS_withAccuracy: (CLLocationAccuracy)accuracy
                andDistanceFilter: (CLLocationDistance)distance;

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon;

- (void)locationManager: (CLLocationManager *)manager 
     didUpdateLocations: (NSArray *)locations;


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end


