
#import "Weather.h"
#import "ShipFit.h"
#import "WeatherDelegate.h"

NSString *const theKey = @"138dc64deba99d47df996e3a3a1c4bd1";
NSString *const baseURL = @"https://api.forecast.io/forecast/";

@implementation Weather
{
    NSDictionary *theweather;
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
             theweather = (NSDictionary *) ([NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error] );
            // Give the UI the Dictionary to work with
             self.shipFit_ref.weatherJSON = theweatherman;

            // lets see what we got
             NSLog( @"%@",theweather.hourly.data[i].time );
             NSLog( @"%@",theweather.hourly.data[i].icon );
             NSLog( @"%@",theweather.hourly.data[i].temperature );
             NSLog( @"%@",theweather.hourly.data[i].windBearing );
             NSLog( @"%@",theweather.hourly.data[i].windSpeed );
             NSLog( @"%@",theweather.hourly.data[i].cloudCover);
             NSLog( @"%@",theweather.hourly.data[i].precipProbability );
             NSLog( @"%@",theweather.hourly.data[i].humidity );
             NSLog( @"%@",theweather.hourly.data[i].pressure );             

             // How do you parse the json? 
             // What do we do with the weather ???
             // Something amazing perhaps..!
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




