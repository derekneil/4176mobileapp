//
//  TableCell.h
//  Ship-Fit
//
//  Created by Ben Irving on 11/19/13.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>


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


