//
//  tableCell.h
//  weatherIPad
//
//  Created by Jander Alves on 2013-11-19.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource> {
    NSDictionary *data;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewInsideCell;
@property (nonatomic, retain) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIImageView *tempImage;
@property (weak, nonatomic) IBOutlet UIImageView *windImage;

@property (weak, nonatomic) IBOutlet UIImageView *conditionImage;

@property (weak, nonatomic) IBOutlet UILabel *minTemp;

@property (weak, nonatomic) IBOutlet UILabel *maxTemp;
@property (weak, nonatomic) IBOutlet UILabel *curTemp;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *condition;
@property (weak, nonatomic) IBOutlet UILabel *pressure;

@end
