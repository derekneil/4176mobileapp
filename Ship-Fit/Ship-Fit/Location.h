#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;

// Enumeration for modes of GPS
enum GPS_OPERATION_MODE
{
    SAILING_STARTUP, // Captures all location events
    SAILING_ROUGH,   // Polls the GPS every 15 seconds
    SAILING_SMOOTH   // Polls the GPS every 60 seconds (uses predictive GPS in between pollings)
};

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;

@property (nonatomic, readwrite, assign) BOOL GPSisValid; 

@property (nonatomic, readwrite, assign) enum GPS_OPERATION_MODE GPS_MODE;


- (id) initWithReference: (ShipFit *)reference;
- (void)init_GPSLOGS;

- (void)halt_GPS;
- (void)run_GPS:(NSTimer*)timer;
- (void)log_latitude: (CLLocationDegrees)lat
           longitude: (CLLocationDegrees)lon
           timestamp: (double)time;

// Location Manager Fire Method for all location based events.
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

// Maybe deal with some errors?
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end