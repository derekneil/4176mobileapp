
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ShipFit;

@interface Direction : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;


/* Class Inititializer */
- (id) initWithReference: (ShipFit *)reference;


- (void)run_compass;
- (void)halt_compass;
- (void)set_bearing;
+ (NSString*)bearing_String:(double)deg;
- (BOOL)straight_travel;

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading;

/* Errors */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end
