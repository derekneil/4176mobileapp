//
//  MainViewController.h
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewController.h"
#import "ViewArticleViewController.h"

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface MainViewController : UITableViewController <AddDelegate>

@property(nonatomic, strong) NSManagedObjectContext *myManageObjectContext;

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (IBAction)btnTest:(id)sender;

@end
