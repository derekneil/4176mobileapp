//
//  WeatherViewController.h
//  Ship-Fit
//
//  Created by Ben Irving on 11/19/13.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *conditionImage;
@property (weak, nonatomic) IBOutlet UITableViewCell *tableCell;

@property (retain, nonatomic) IBOutlet UILabel *temperatureCurrent;
@property (retain, nonatomic) IBOutlet UILabel *temperatureMax;
@property (retain, nonatomic) IBOutlet UILabel *temperatureMin;
@property (retain, nonatomic) IBOutlet UILabel *conditionLabel;

@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property UIImage * condition;
@property UIImage *wind;
@property (retain, nonatomic) IBOutlet UIImageView *windIcon;
@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (weak, nonatomic) IBOutlet UIImageView *maxTemp;
@property (weak, nonatomic) IBOutlet UIImageView *minTemp;
@property (weak, nonatomic) IBOutlet UILabel *cloudCover;
@property (weak, nonatomic) IBOutlet UILabel *precipitation;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pressure;

@property NSMutableArray *daysStored;
@property NSMutableArray *hoursStored;

@end
