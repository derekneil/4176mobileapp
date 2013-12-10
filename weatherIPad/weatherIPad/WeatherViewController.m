//
//  SimViewController.m
//  Weather
//
//  Created by Jander Alves on 2013-11-16.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "WeatherViewController.h"

@interface SimViewController ()

@end

@implementation SimViewController

@synthesize condition;
- (void)viewDidLoad
{

    [super viewDidLoad];
    [self setLabels];
    [self setImages];
    _hoursStored = [[NSMutableArray alloc]initWithObjects: @"11",@"12", @"13",nil];
  
    titleSource = [[NSMutableArray alloc] initWithObjects: @"Monday", @"Tuesday", @"Wednesday", nil];
    _tableView.dataSource = self;
    _tableView.delegate = self;
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //need to make a count of how many days were saved
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 48;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    
    tableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[tableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.windImage.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];
    cell.tempImage.image =  [UIImage imageNamed:@"thermometer.jpeg"];
    cell.maxTemp.text = @"test temp";
    
    return cell;
   }






- (void)viewDidUnload {
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

#pragma mark - top view methods


 
- (void) setLabels{
    [_conditionLabel setText:@"clear"];
    [_temperatureCurrent setText:@"5C"];
    [_temperatureMax setText:@"Max: 10C"];
    [_temperatureMin setText:@"Min: 2C"];
    [_windSpeed setText: @"Wind Speed: 5KH"];
    [_cloudCover setText:@"2"];
    [_pressure setText:@"1020"];
    [_precipitation setText:@"2%"];
    
}

- (void) setImages {
    //condition image
    condition =[UIImage imageNamed:@"Status-weather-clear-icon.png"];
    _conditionImage = [[UIImageView alloc]initWithImage:condition];
    [_viewController addSubview:_conditionImage];
        _windIcon.image = [UIImage imageNamed:@"Wind-Flag-Storm-icon.png"];//windspeed icon
    [_viewController addSubview:_windIcon];
    _maxTemp.image = [UIImage imageNamed:@"thermometer.jpeg"];
    _minTemp.image = [UIImage imageNamed:@"thermometer.jpeg"];
}


@end
