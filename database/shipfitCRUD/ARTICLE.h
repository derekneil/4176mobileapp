//
//  ARTICLE.h
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ARTICLE : NSManagedObject

@property (nonatomic, retain) NSString * mainText;
@property (nonatomic, retain) NSString * title;

@end
