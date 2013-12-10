//
//  TableViewCell.h
//  TableViewInsideCell
//
//  Created by Bushra on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource> {
    NSDictionary *data;
}

@property (nonatomic, retain) IBOutlet UITableView *tableViewInsideCell;
@property (nonatomic, retain) NSDictionary *data;

@end
