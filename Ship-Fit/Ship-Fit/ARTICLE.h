//
//  ARTICLE.h
//  Ship-Fit
//
//  Created by Derek Neil on 2013-11-13.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"


@interface ARTICLE : NSManagedObject

@property (nonatomic, retain) NSNumber * chapter;
@property (nonatomic, retain) NSString * indexID;
@property (nonatomic, retain) NSString * mainText;
@property (nonatomic, retain) NSString * title;

@end
