//
//  SimViewController.m
//  Weather
//
//  Created by Jander Alves on 2013-11-16.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "SimViewController.h"

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
    return [titleSource count];//need to make a count of how many days were saved
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _hoursStored.count;//make a count of how many hours were saed per day
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UILabel *temperature = [[UILabel alloc]init];
    temperature.text = @"current temp for this hour";
    temperature.textAlignment = NSTextAlignmentRight;//change this method for ios5.1
    [cell.contentView addSubview:temperature];
    cell.textLabel.text = @"whatever";
    cell.imageView.image = [UIImage imageNamed:@"Status-weather-clear-icon.png"];
    NSLog(@"%d",indexPath.row);
    cell.detailTextLabel.text = temperature.text;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    for (int i =0; i<_hoursStored.count;i++) {
        
    
    if(section == i)
    {
        return [titleSource objectAtIndex:i];
    }
    }
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
    [super viewDidUnload];
}

#pragma mark - top view methods


 
- (void) setLabels{
    [_conditionLabel setText:@"clear"];
    [_temperatureCurrent setText:@"5C"];
    [_temperatureMax setText:@"Max: 10C"];
    [_temperatureMin setText:@"Min: 2C"];
    [_windSpeed setText: @"Wind Speed: 5KH"];
    [_tableView setBackgroundView:_conditionImage];
    _windIcon.image = [UIImage imageNamed:@"Wind-Flag-Storm-Icon.png"];
    
}

- (void) setImages {
    _conditionImage = [[UIImageView alloc]init];
    condition =[UIImage imageNamed:@"Status-weather-clear-icon.png"];
    [_conditionImage setImage:condition];
}






@end
