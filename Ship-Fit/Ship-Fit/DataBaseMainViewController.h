//
//  DatabaseMainViewController.h
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseArticleViewController.h"

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "SMXMLDocument.h"


@interface DatabaseMainViewController : UITableViewController <UISearchBarDelegate>

@property(nonatomic, strong) NSManagedObjectContext *myManageObjectContext;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UISearchBar *databaseSearchBar;

- (IBAction)btnTest:(id)sender;

@end
