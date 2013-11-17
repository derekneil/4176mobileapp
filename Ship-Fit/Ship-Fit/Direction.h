
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;

@interface Direction : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;

/* Class Inititializer */
- (id) initWithReference: (ShipFit *)reference;

- (void)init_logs_and_manager;

- (void)run_compass_withFilter: (CLLocationDegrees)compass_accuracy;
- (void)halt_compass;
- (void)set_bearing;
+ (NSString*)bearing_String:(float)deg;

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading;

/* Errors */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end
