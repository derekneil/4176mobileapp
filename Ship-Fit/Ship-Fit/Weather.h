
#import <Foundation/Foundation.h>

extern NSString *const theKEY;
extern NSString *const baseURL;

@class ShipFit;

@interface Weather : NSObject

@property (nonatomic, readwrite, strong) ShipFit *shipFit_ref;

- (id) initWithReference: (ShipFit *)reference;

- (void)getWeatherForLatitude: (double)lat
                    Longitude: (double)lon
                         Time: (double)time;
@end
