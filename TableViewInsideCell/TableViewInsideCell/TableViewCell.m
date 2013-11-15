//
//  TableViewCell.m
//  TableViewInsideCell
//
//  Created by Bushra on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize tableViewInsideCell;
@synthesize data;

- (void)dealloc {
    [data release];
    [tableViewInsideCell release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Temperature High";
            cell.detailTextLabel.text = [data objectForKey:@"Temperature High"];
            break;
        case 1:
            cell.textLabel.text = @"Temperature Low";
            cell.detailTextLabel.text = [data objectForKey:@"Temperature Low"];
            break;
        case 2:
            cell.textLabel.text = @"Temperature Current";
            cell.detailTextLabel.text = [data objectForKey:@"Temperature Current"];
            break;
        case 3:
            cell.textLabel.text = @"Altitude";
            cell.detailTextLabel.text = [data objectForKey:@"Altitude"];
            break;
        case 4:
            cell.textLabel.text = @"Date";
            cell.detailTextLabel.text = [data objectForKey:@"Date"];
            break;
        case 5:
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = [data objectForKey:@"Time"];
            break;
        case 6:
            cell.textLabel.text = @"Wind Speed";
            cell.detailTextLabel.text = [data objectForKey:@"Wind Speed"];
            break;
        case 7:
            cell.textLabel.text = @"Wind Direction";
            cell.detailTextLabel.text = [data objectForKey:@"Wind Direction"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}


@end
