
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
    NSURL *theURL = [ NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%.6f,%.6f",baseURL,theKey,lat,lon] ];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:theURL
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:10];
    
    
    NSLog(@"Getting Forecast for: %@ " , theURL );
    [ NSURLConnection sendAsynchronousRequest:request
                                        queue:[[NSOperationQueue alloc] init]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {	
         if (error)
         {
             NSLog(@"failure");
             NSLog(@"%@" , error);
             
         } else
         {
             NSLog(@"success!!");
             id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
             NSLog(@"%@", jsonObject);
         }
     }];
}


@end

//handle timeouts
//if you hit the timeout then you have no weather available and you will have to use the cached weather. 




