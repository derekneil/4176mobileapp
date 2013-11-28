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
    self.view.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-background.jpg"] ];
}

- (void)viewWillAppear:(BOOL)animated
{
	// If we already have weather
    if ( [self.shipfit_ref get_weather_status] )
    {
        hourly_weather = [ [ self.shipfit_ref.weatherJSON objectForKey:@"hourly" ] objectForKey:@"data" ];
        [self set_timer_and_run_weather];
    }
    
    // observe the JSON object for the changes
    [self.shipfit_ref addObserver:self
                       forKeyPath:@"weatherJSON"
                          options:NSKeyValueObservingOptionNew
                          context:nil ];

    // set the base images
	self.windImage.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];
	self.tempImage.image =  [UIImage imageNamed:@"Thermometer.png"];
	self.pressureImage.image = [UIImage imageNamed:@"barometer4.png"];
    self.popImage.image = [ UIImage imageNamed:@"Status-weather-showers-icon.png"];
    self.cloudcoverImage.image = [ UIImage imageNamed:@"Status-weather-many-clouds-icon.png"];
    self.visImage.image = [ UIImage imageNamed:@"sun-glasses-icon.png"];
    self.calendarImage.image = [UIImage imageNamed:@"calendar.png"];
    
    //set the additional information
}

// observe the changes in the weatherJSON pointer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [keyPath isEqualToString:@"weatherJSON" ] )
    {
        hourly_weather = [ [ [change objectForKey:NSKeyValueChangeNewKey] objectForKey:@"hourly" ] objectForKey:@"data" ];
        [self performSelectorOnMainThread:@selector(set_timer_and_run_weather) withObject:nil waitUntilDone:NO];
    }
}

// start the weather visualization from the beginnning
- (void)set_timer_and_run_weather
{
    _count = 0;
    [self weather_explosion:nil];
	_theWeatherTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                        target:self
                                                      selector:@selector(weather_explosion:)
                                                      userInfo:nil
                                                       repeats:YES];
    
    //set up the slider
    [self.slider addTarget:self action:@selector(slider_control:) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 47;
}

- (void)slider_control: (id)sender
{
    _count = self.slider.value;
    [self weather_explosion:nil];
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
		self.temperatureCurrent.text = [NSString stringWithFormat:@"%.f\u00B0C", [WeatherViewController degFtoDegC: [weather_data valueForKey:@"temperature"] ] ];

        // Time
		[self set_time:[[ weather_data valueForKey:@"time"] doubleValue]];

		
        //pressure
		self.pressure.text = [ NSString stringWithFormat:@"%.d mbar" , [[weather_data valueForKey:@"pressure"] intValue]];

      	//precipitation && clouds
		self.precipitation.text = [ NSString stringWithFormat:@"%.0f %% POP" , 100 * [ [weather_data valueForKey:@"precipProbability"] doubleValue ] ];
		self.cloudCover.text =  [ NSString stringWithFormat:@"%.0f %% Cloud Cover" , 100 * [ [ weather_data valueForKey:@"cloudCover"] doubleValue ] ];

		//visibility 
		self.visibility.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"visibility"] ];

        //additional info
        self.additionalInfo.text = [ NSString stringWithFormat:@"%@" , [ weather_data valueForKey:@"precipType"] ];

        [self.slider setValue:_count animated:YES];
		_count++;
	}   
}

- (IBAction)pause_explosion: (id)sender
{
	if (_theWeatherTimer != nil)
    {
        [ _theWeatherTimer invalidate ];
        _theWeatherTimer = nil;
    }
    self.pause_button.hidden = YES;
}


- (IBAction)play_explosion: (id)sender
{
	[self weather_explosion:nil];
	_theWeatherTimer = [ NSTimer scheduledTimerWithTimeInterval:1.5
                                                         target:self
                                                       selector:@selector(weather_explosion:)
                                                       userInfo:nil repeats:YES];
    self.pause_button.hidden = NO;
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
   
    NSDateComponents *date_components = [[NSCalendar currentCalendar] components: kCFCalendarUnitHour | kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear | kCFCalendarUnitWeekday fromDate:date ];
    
    NSMutableString *result= [ [NSMutableString alloc] init];
    
    [result appendString:[WeatherViewController getDayOfWeekStr:[date_components weekday]]];
    [result appendString:@", "];
    [result appendString:[WeatherViewController getMonthOfYearStr:[date_components month]]];
    [result appendString:[NSString stringWithFormat:@"%i ",[date_components day]]];
    [result appendString:[WeatherViewController getHourOfDayStr:[date_components hour]]];
    
    self.time.text = result;
}

+ (NSString *)getDayOfWeekStr: (NSInteger)dayOfWeek
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

+ (NSString *)getMonthOfYearStr: (NSInteger)month
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

+ (NSString*)getHourOfDayStr: (NSInteger)hours
{
    if (hours==0){
        hours+=12;
        return [NSString stringWithFormat:@"%i AM",hours];
    }
    else if (hours < 12){
        return [NSString stringWithFormat:@"%i AM",hours];
    }
    else if (hours == 12 ){
        return [NSString stringWithFormat:@"%i PM",hours];
    }
    else{
        hours -=12;
        return [NSString stringWithFormat:@"%i PM",hours];
    }
}
    

+ (double)degFtoDegC: (NSString *)input
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
    [self.shipfit_ref removeObserver:self forKeyPath:@"weatherJSON"];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




