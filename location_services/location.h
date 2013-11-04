#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;
@class MKMapView;

@interface location : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

//properties
@property (nonatomic, readwrite, strong) ShipFit *shipIt_ref;
@property (nonatomic, readwrite, strong) MKMapView *map_ref;



- (id) initWithShipFitReference: (ShipFit *)reference andMKMapReference: (MKMapView *)map;

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

#if 0 

@property (nonatomic, readwrite, strong) CLLocationManager *gps_manager;
@property (nonatomic, readwrite, strong) CLLocationManager *compass_manager;

#endif
