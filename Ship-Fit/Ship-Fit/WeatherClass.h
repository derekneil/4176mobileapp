//
//  WeatherClass.h
//  Ship-Fit
//
//  Created by hamid on 2013-11-18.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherClass : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *JSON;
@property (nonatomic,strong) NSString *dateandtime;


@end
