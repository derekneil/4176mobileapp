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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-background.jpg"]];
}


- (void)viewWillAppear:(BOOL)animated
{
	_count = 0;
	hourly_weather = [ [ self.shipfit_ref.weatherJSON objectForKey:@"hourly" ] objectForKey:@"data" ];

    // set the base images
	self.windImage.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];
	self.tempImage.image =  [UIImage imageNamed:@"Thermometer.png"];
	self.pressureImage.image = [UIImage imageNamed:@"barometer2.jpg"];
    self.popImage.image = [ UIImage imageNamed:@"Status-weather-showers-icon.png"];
    self.cloudcoverImage.image = [ UIImage imageNamed:@"Status-weather-many-clouds-icon.png"];
    self.visImage.image = [ UIImage imageNamed:@"sun-glasses-icon.png"];
    self.calendarImage.image = [UIImage imageNamed:@"calendar.png"];
    
    [self weather_explosion:nil];
	_theWeatherTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                        target:self
                                                      selector:@selector(weather_explosion:) userInfo:nil repeats:YES];
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
		self.conditionImage.image = [UIImage imageNamed:[self imageNameForWeatherIconType:[NSString stringWithFormat:@"%@",[weather_data valueForKey:@"icon"] ] ] ];

        //Wind Related
		self.windSpeed.text = [NSString stringWithFormat:@"%.f KM/H",[ [weather_data valueForKey:@"windSpeed"] doubleValue ] * 1.609344 ];
		self.windDirection.text = [ Direction bearing_String:[[ weather_data valueForKey:@"windBearing"] doubleValue] ];

        // Temperature Related
		self.temperatureCurrent.text = [NSString stringWithFormat:@"%.1f \u00B0 C", [self set_temp: [weather_data valueForKey:@"temperature"] ] ];

        // Time
		[self set_time:[[ weather_data valueForKey:@"time"] doubleValue]];

		
        //pressure
		self.pressure.text = [ NSString stringWithFormat:@"%@ mbar" , [weather_data valueForKey:@"pressure"] ];

      	//precipitation && clouds
		self.precipitation.text = [ NSString stringWithFormat:@"%.0f %% POP" , 100 * [ [weather_data valueForKey:@"precipProbability"] doubleValue ] ];
		self.cloudCover.text =  [ NSString stringWithFormat:@"%.0f %% Cloud Cover" , 100 * [ [ weather_data valueForKey:@"cloudCover"] doubleValue ] ];

		//visibility 
		self.visibility.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"visibility"] ];

        //additional info
        self.additionalInfo.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"precipType"] ];

		_count++;
	}   
}

- (IBAction)pause_explosion: (id)sender
{
	[ _theWeatherTimer invalidate ];
	_theWeatherTimer = nil;
}


- (IBAction)restart_explosion: (id)sender
{
	_count = 0;
	[self weather_explosion:nil];
	_theWeatherTimer = [ NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(weather_explosion:) userInfo:nil repeats:YES];
    
}

- (IBAction)go_back_one: (id)sender
{
	_count -= 2;
	[self weather_explosion:nil];
}

- (IBAction)go_forward_one: (id)sender
{
	[self weather_explosion:nil];
}

- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription
{
	//NSLog(@"%@",iconDescription);
    if ([iconDescription isEqualToString:@"clear-day" ]) { return @"Status-weather-clear-icon.png"; }
	else if ([iconDescription isEqualToString:@"clear-night"]) { return @"Status-weather-clear-night-icon.png"; }
	else if ([iconDescription isEqualToString:@"rain"]) { return @"Status-weather-showers-icon.png"; }
	else if ([iconDescription isEqualToString:@"snow"]) { return @"Status-weather-snow-icon.png"; }
	else if ([iconDescription isEqualToString:@"sleet"]) { return @"Status-weather-snow-rain-icon.png"; }
	else if ([iconDescription isEqualToString:@"wind"]) { return @"Wind-Flag-Storm-icon.png"; }
	else if ([iconDescription isEqualToString:@"fog"]) { return @"Fog-icon.png"; }
	else if ([iconDescription isEqualToString:@"cloudy"]) { return @"Status-weather-many-clouds-icon.png"; }
	else if ([iconDescription isEqualToString:@"partly-cloudy-day"]) { return @"Status-weather-clouds-icon.png"; }
	else if ([iconDescription isEqualToString:@"partly-cloudy-night"]) { return @"Status-weather-clouds-night-icon.png"; }
	else if ([iconDescription isEqualToString:@"hail"]) { return @"Hail-Heavy-icon.png"; }
	else if ([iconDescription isEqualToString:@"thunderstorm"]) { return @"thunderstorm.png"; }
	else if ([iconDescription isEqualToString:@"tornado"]) { return @"tornado-icon.png"; }
    else return @"Status-weather-clouds-icon.png"; // Default in case nothing matched
}



// SET THE TIME 
-(void)set_time: (double)Time
{	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:Time];
   
    NSDateComponents *date_components = [[NSCalendar currentCalendar] components:kCFCalendarUnitHour | kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear | kCFCalendarUnitWeekday fromDate:date ];
    
    NSMutableString *result= [ [NSMutableString alloc] init];
    
    [result appendString:[ self set_day_of_week:[date_components weekday]]];
    [result appendString:@", "];
    [result appendString:[self set_month_of_year:[date_components month]]];
    [result appendString:[NSString stringWithFormat:@"%i ",[date_components day]]];
    [result appendString:[self set_hour_of_day:[date_components hour]]];
    
    self.time.text = result;
    
//    NSLog(@"%i",[date_components weekday]);
//    NSLog(@"%i",[date_components day]);
//    NSLog(@"%i",[date_components month]);
//    NSLog(@"%i",[date_components year]);
//    NSLog(@"%i",[date_components hour]);
    
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

- (NSString *)set_month_of_year: (NSInteger)month
{
	if (month == 1){  return @"January "; }
	else if (month == 2){ return @"February "; }
	else if (month == 3){ return @"March ";}
	else if (month == 4){return @"April ";}
	else if (month == 5){ return @"May "; }
	else if (month == 6){ return @"June "; }
	else if (month == 7){ return @"July "; }
    else if (month == 8){ return @"August "; }
	else if (month == 9){ return @"September ";}
	else if (month == 10){return @"October ";}
	else if (month == 11){ return @"November "; }
	else if (month == 12){ return @"December "; }
	else { return @"Error"; }
}

- (NSString*)set_hour_of_day: (NSInteger)hours
{
    if (hours==0)
    {
        hours+=12;
        return [NSString stringWithFormat:@"%i AM",hours];
    }
    else if (hours < 12)
    {
        return [NSString stringWithFormat:@"%i AM",hours];
    }
    else if (hours == 12 )
    {
        return [NSString stringWithFormat:@"%i PM",hours];
    }
    else{
        hours -=12;
        return [NSString stringWithFormat:@"%i PM",hours];
    }
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

- (void)viewWillDisappear:(BOOL)animated
{
    [_theWeatherTimer invalidate];
    _theWeatherTimer = nil;
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




