//
//  TableViewController.h
//  TableViewInsideCell
//
//  Created by Bushra on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCell;

@interface TableViewController : UITableViewController {
    NSArray *dataArray;
}

@property (nonatomic, retain) IBOutlet TableViewCell *tableViewCellWithTableView;

@end
