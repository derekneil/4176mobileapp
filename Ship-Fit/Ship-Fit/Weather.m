
#import "Weather.h"
#import "ShipFit.h"

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
        _weatherHasArrived = NO;
    }
    return self;
}

- (void)getWeatherForLatitude: (double)lat
                    Longitude: (double)lon
                         Time: (double)timetime  // Unused parameter thus far.  Predicted Weather For the Future
{
    //
    // Build the URL string 
    // JUST LOCATION 
    // NO TIME
    NSURL *theURL = [ NSURL URLWithString: [ NSString stringWithFormat:@"%@%@/%.6f,%.6f",baseURL,theKey,lat,lon ] ];
    
    // Make the Asynchronous call to the API
    NSLog(@"Getting Forecast for: %@ " , theURL );
    [ NSURLConnection sendAsynchronousRequest:[ [NSURLRequest alloc] initWithURL:theURL cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval: 45 ]
                                        queue:[[NSOperationQueue alloc] init]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {	
         if (error)
         {
             NSLog(@"%@" , error);
         }
         else
         {
             NSLog(@"JSON Received");
              id json = ([NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error] );
            
             if ( [ json isKindOfClass:[NSDictionary class ] ] )
             {
                self.shipFit_ref.weatherJSON = (NSDictionary *)json;
                self.weatherHasArrived = YES;
             }
         }
     } 
     ]; 
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [keyPath isEqualToString:@"GPSisValid" ] )
    {
        // make the call
        [self getWeatherForLatitude: self.shipFit_ref.latitude
                          Longitude: self.shipFit_ref.longitude
                               Time:0];
    }
    
}

@end


// state machine?
// Weather startup phase
// Weather caching phase
// How often to update weather??

//handle timeouts
//if you hit the timeout then you have no weather available and you will have to use the cached weather.