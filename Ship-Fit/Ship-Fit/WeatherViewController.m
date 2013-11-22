#import "WeatherViewController.h"
#import "TableCell.h"
#import "Direction.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController
{
    NSArray *hourly_weather;
}

@synthesize condition;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setLabels];
    [self setImages];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    hourly_weather = [ [self.shipfit_ref.weatherJSON objectForKey:@"hourly"] objectForKey:@"data"];
    //NSLog(@"%@",hourly_weather[0]);
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%i",indexPath.row);
    // Set up the default layout of the cell
    static NSString * cellIdentifier = @"cell";
    TableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[TableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.windImage.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];
    cell.tempImage.image =  [UIImage imageNamed:@"thermometer.jpeg"];
    cell.pressureImage.image = [UIImage imageNamed:@"pressure.jpeg"];
    
    // Populate With JSON Data
    // Get the Dictionary for the entry
    NSDictionary *weather_data = hourly_weather[indexPath.row];
    
    // Temperature Related
    cell.curTemp.text = [NSString stringWithFormat:@"Temperature: %.1f \u00B0 C", [self set_temp: [weather_data valueForKey:@"temperature"] ] ];
    
    // Wind Related
    cell.windSpeed.text = [NSString stringWithFormat:@"%@",[weather_data valueForKey:@"windSpeed"]];
    cell.windDirection.text = [ Direction bearing_String:[[ weather_data valueForKey:@"windBearing"] doubleValue] ];

    // Icon
    cell.conditionImage.image = [UIImage imageNamed:[self imageNameForWeatherIconType:[NSString stringWithFormat:@"%@",[weather_data valueForKey:@"icon"] ] ] ];
    
    // Time
    double Time = [[ weather_data valueForKey:@"time"] doubleValue] ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:Time];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    cell.timeLabel.text = [ NSString stringWithFormat:@"%i:%i" ,components.hour, components.minute ];
    
    //pressure
    cell.pressure.text = [ NSString stringWithFormat:@"%@" , [weather_data valueForKey:@"pressure"]];
    
    
    
    
    
    
    return cell;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //need to make a count of how many days were saved
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 24;
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
    //else if ([iconDescription isEqualToString:]) { return @"hail.png"; }
    //else if ([iconDescription isEqualToString:]) { return @"thunderstorm.png"; }
    //else if ([iconDescription isEqualToString:]) { return @"tornado.png"; }
    //else if ([iconDescription isEqualToString:]) { return @"hurricane.png"; }
    else return @"Status-weather-clouds-icon.png"; // Default in case nothing matched
}


//
//cell.minTemp.text = [NSString stringWithFormat:@"%@",[weather_data valueForKey:@"temperatureMin"]];
//NSDictionary* currently = [weatherJSON objectForKey:@"currently"];
//self.tempLabel.text = [NSString stringWithFormat:@"%@",[currently valueForKey:@"temperature"]];
//self.windLabel.text = [NSString stringWithFormat:@"%@",[currently valueForKey:@"windSpeed"]];
//self.windDirLabel.text = ;
//
//NSArray* temp = [[weatherJSON objectForKey:@"daily"] objectForKey:@"data"];
//NSDictionary* today = temp[0];
//self.tempHighLabel.text = [NSString stringWithFormat:@"%@",[today valueForKey:@"temperatureMax"]];
//self.tempLoLabel.text = [NSString stringWithFormat:@"%@",[today valueForKey:@"temperatureMin"]];
//self.sunLabel.text = [NSString stringWithFormat:@"%@",[today valueForKey:@"sunsetTime"]];
//



//apparentTemperature = "55.99";
//cloudCover = "0.99";
//dewPoint = "54.6";
//humidity = "0.95";
//icon = cloudy;
//ozone = "277.74";
//precipIntensity = "0.0025";
//precipProbability = "0.06";
//precipType = rain;
//pressure = "1012.74";
//summary = Overcast;
//temperature = "55.99";
//time = 1384963200;
//visibility = "7.57";
//windBearing = 176;
//windSpeed = "4.45";




- (void)viewDidUnload
{
    //[self setTemperatureImage:nil];
#if 0
    [self setTemperatureCurrent:nil];
    [self setTemperatureMax:nil];
    [self setTemperatureMin:nil];
#endif
    [self setConditionImage:nil];
    [self setWindSpeed:nil];
    [self setWindIcon:nil];
    [self setViewController:nil];
    [self setMaxTemp:nil];
    [self setMinTemp:nil];
    [self setWindDirection:nil];
    [self setCloudCover:nil];
    [self setPrecipitation:nil];
    [self setTime:nil];
    [self setPressure:nil];
    [super viewDidUnload];
}


- (void) setLabels
{
    [_conditionLabel setText:@"clear"];
    [_temperatureCurrent setText:@"5C"];
    [_temperatureMax setText:@"Max: 10C"];
    [_temperatureMin setText:@"Min: 2C"];
    [_windSpeed setText: @"Wind Speed: 5KH"];
    [_cloudCover setText:@"2"];
    [_pressure setText:@"1020"];
    [_precipitation setText:@"2%"];
    
}

- (void) setImages
{
    //condition image
    condition =[UIImage imageNamed:@"Status-weather-clear-icon.png"];
    _conditionImage = [[UIImageView alloc]initWithImage:condition];
    [_viewController addSubview:_conditionImage];
    _windIcon.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];//windspeed icon
    [_viewController addSubview:_windIcon];
    _maxTemp.image = [UIImage imageNamed:@"thermometer.jpeg"];
    _minTemp.image = [UIImage imageNamed:@"thermometer.jpeg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
