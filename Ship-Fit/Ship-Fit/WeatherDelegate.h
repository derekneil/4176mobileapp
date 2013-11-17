
#import <Foundation/Foundation.h>

@protocol WeatherDelegate

- (void)receivedJSON:(NSData *)objectNotation;
- (void)fetchingWeatherFailedWithError:(NSError *)error;

@end
