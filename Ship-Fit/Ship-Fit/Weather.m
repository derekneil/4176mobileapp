
#import "Weather.h"
#import "ShipFit.h"
#import "WeatherDelegate.h"

NSString *const theKey = @"138dc64deba99d47df996e3a3a1c4bd1";
NSString *const baseURL = @"https://api.forecast.io/forecast/";

@implementation Weather
{

}

- (id) initWithReference: (ShipFit *)reference
{
    self = [super init];
    if ( self ){
        _shipFit_ref = reference;
    }
    return self;
}

- (void)getWeatherForLatitude: (double)lat
                    Longitude: (double)lon
                         Time: (double)time
{
    // Build the URL string
    NSURL *theURL = [ NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%.6f,%.6f",baseURL,theKey,lat,lon] ];
    
    // Make the Asynchronous call to the API
    NSLog(@"Getting Forecast for: %@ " , theURL );
    [ NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:theURL
                                                                    cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                                timeoutInterval:8 ]
                                        queue:[[NSOperationQueue alloc] init]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {	
         if (error)
         {
             NSLog(@"The Call to Forecast.io was not successful.");
             NSLog(@"%@" , error);
         }
         else
         {
             id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
             
             if ( [jsonObject isKindOfClass:[NSDictionary class ] ])
             {
                 NSLog(@"Weather JSON saved to ShipFit Property");
                 self.shipFit_ref.weatherJSON = (NSDictionary *)jsonObject;
             }
         }
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [keyPath isEqualToString:@"GPSisValid" ] )
    {
        // make the call
        [self getWeatherForLatitude:self.shipFit_ref.latitude
                          Longitude:self.shipFit_ref.longitude
                               Time:  1   ];
    }
    
}

@end


// state machine?
// Weather startup phase
// Weather caching phase
// How often to update weather??

//handle timeouts
//if you hit the timeout then you have no weather available and you will have to use the cached weather. 




