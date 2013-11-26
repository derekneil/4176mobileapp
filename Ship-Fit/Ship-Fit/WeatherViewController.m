#import "WeatherViewController.h"
#import "TableCell.h"
#import "Direction.h"

@implementation WeatherViewController
{
	NSArray *hourly_weather;
	int _count;
	NSTimer *_theWeatherTimer;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
	_count = 0;
	hourly_weather = [ [ self.shipfit_ref.weatherJSON objectForKey:@"hourly" ] objectForKey:@"data" ];

    // set the base images
	self.wind.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];
	self.tempImage.image =  [UIImage imageNamed:@"thermometer.jpeg"];
	self.pressure.image = [UIImage imageNamed:@"pressure.jpeg"];

	[self weather_explosion:nil];
	_theWeatherTimer = [ NSTimer timerWithTimeInterval:1.5
		target:self
		selector:@selector(weather_explosion:)
		userInfo:nil
		repeats:YES];
}

- (void)weather_explosion: (NSTimer*)theWeatherTimer
{
	if (_count >= 48 && _theWeatherTimer!= nil)
	{
		[_theWeatherTimer invalidate];
		_theWeatherTimer = nil;
	}
	else{
		NSDictionary *weather_data = hourly_weather[_count];

        // Condition Icon
		self.condition.image = [UIImage imageNamed:[self imageNameForWeatherIconType:[NSString stringWithFormat:@"%@",[weather_data valueForKey:@"icon"] ] ] ];

        //Wind Related
		self.windSpeed.text = [NSString stringWithFormat:@"%@",[weather_data valueForKey:@"windSpeed"]];
		self.windDirection.text = [ Direction bearing_String:[[ weather_data valueForKey:@"windBearing"] doubleValue] ];

        // Temperature Related
		self.temperatureCurrent.text = [NSString stringWithFormat:@"Temperature: %.1f \u00B0 C", [self set_temp: [weather_data valueForKey:@"temperature"] ] ];

        // Time
		self.set_time( [[ [ weather_data valueForKey:@"time"] doubleValue]]);

		
        //pressure
		self.pressure.text = [ NSString stringWithFormat:@"%@" , [weather_data valueForKey:@"pressure"] ];

      	//precipitation && clouds
		self.precipitation.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"precipProbability"] ];  
		self.rainType.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"precipType"] ];
		self.cloudCover.text =  [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"cloudCover"] ];

		//visibility 
		self.visibility.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"cloudCover"] ]; 


		_count++;
	}   
}

- (void)pause_explosion: (id)sender
{
	[ _theWeatherTimer invalidate ];
	_theWeatherTimer = nil;
}



- (void)restart_explosion: (id)sender
{
	_count = 0;
	[self weather_explosion:nil];
	_theWeatherTimer = [ NSTimer timerWithTimeInterval:1.5
		target:self
		selector:@selector(weather_explosion:)
		userInfo:nil
		repeats:YES];
}

- (void)go_back_one
{
	_count--;
	[self weather_explosion:nil];
}

- (void)go_forward_one
{
	_count++;
	[self weather_explosion:nil];
}

- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription
{
	if ([iconDescription isEqualToString:@"clear-day" ]) { return @"Status-weather-clear-icon.png"; }
	else if ([iconDescription isEqualToString:@"clear-night"]) { return @"Status-weather-clear-night-icon.png"; }
	else if ([iconDescription isEqualToString:@"rain"]) { return @"Status-weather-showers-icon.png"; }
	else if ([iconDescription isEqualToString:@"snow"]) { return @"Status-weather-snow-icon.png"; }
	else if ([iconDescription isEqualToString:@"sleet"]) { return @"Status-weather-snow-rain-icon.png"; }
	else if ([iconDescription isEqualToString:@"wind"]) { return @"Wind-Flag-Storm-icon.png"; }
	else if ([iconDescription isEqualToString:@"fog"]) { return @"Fog-icon.png"; }
	else if ([iconDescription isEqualToString:@"cloudy"]) { return @"Status-weather-many-clouds.png"; }
	else if ([iconDescription isEqualToString:@"partly-cloudy-day"]) { return @"Status-weather-clouds-icon.png"; }
	else if ([iconDescription isEqualToString:@"partly-cloudy-night"]) { return @"Status-weather-clouds-night-icon.png"; }
	else if ([iconDescription isEqualToString:]) { return @"hail.png"; }
	else if ([iconDescription isEqualToString:]) { return @"thunderstorm.png"; }
	else if ([iconDescription isEqualToString:]) { return @"tornado.png"; }
	else if ([iconDescription isEqualToString:]) { return @"hurricane.png"; }
    else return @"Status-weather-clouds-icon.png"; // Default in case nothing matched
}



// SET THE TIME 
-(void)setTime: (double)Time
{	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:Time];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
	self.time.text = [ NSString stringWithFormat:@"Time (GMT) : %2i:%2i" , components.hour, components.minute ];
}

- (NSString *)set_day_of_week: (NSInteger)dayOfWeek
{
	if (dayOfWeek == 1){  return @"Sunday"; }
	else if (dayOfWeek == 2){ return @"Monday"; }
	else if (dayOfWeek == 3){ return @"Tuesday";}
	else if (dayOfWeek == 4){return @"Wednesday";}
	else if (dayOfWeek == 5){ return @"Thursday"; }
	else if (dayOfWeek == 6){ return @"Friday"; }
	else if (dayOfWeek == 7){ return @"Saturday"; }
	else { return @"Error"; }
}


- (double)set_temp: (NSString *)input
{
	double x;
	x = [input doubleValue];
	x = (x - 32) / 1.8;
	return x;
}

- (void)viewDidUnload
{
    //TO DO
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

// play button 
// stop button
// from the beginning
// do you think that a visualization of the weather would be good? 
// or do you think that the old way with the table views was better?
// need background
//humidity = "0.95";
//ozone = "277.74";




