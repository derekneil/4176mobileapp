//
//  GPS.h
//  Ship-Fit
//
//  Created by hamid on 2013-11-15.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <Foundation/Foundation.h>

//(NSInteger)tripID lat:(NSString *)lat lng:(NSString *)lng dateandtime:(NSString *)dateandtime


@interface GPS : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,assign) int tripID;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *dateandtime;

@end
