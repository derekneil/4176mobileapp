#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;

enum GPS_OPERATION_MODE
{
    SAILING_STARTUP,
    SAILING_ROUGH,
    SAILING_SMOOTH
};

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;
@property (nonatomic, readwrite, assign) BOOL logging_enabled;
@property (nonatomic, readwrite, assign) enum GPS_OPERATION_MODE GPS_MODE;

//Flags
@property (nonatomic, readwrite, assign) BOOL GPSisValid;

- (id) initWithReference: (ShipFit *)reference;

- (void)init_logs_and_manager;

- (void)halt_GPS;

- (void)run_GPS:(NSTimer*)timer;

- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon
           timestamp: (double)time;

- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations;


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

/* Errors */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end