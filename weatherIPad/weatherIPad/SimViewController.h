//
//  SimViewController.h
//  weatherIPad
//
//  Created by Jander Alves on 2013-11-16.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * titleSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *conditionImage;

@property (retain, nonatomic) IBOutlet UILabel *temperatureCurrent;
@property (retain, nonatomic) IBOutlet UILabel *temperatureMax;
@property (retain, nonatomic) IBOutlet UILabel *temperatureMin;
@property (retain, nonatomic) IBOutlet UILabel *conditionLabel;

@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property UIImage * condition;
@property (weak, nonatomic) IBOutlet UIImageView *windIcon;

@property NSMutableArray *daysStored;
@property NSMutableArray *hoursStored;

@end


