//
//  TableViewController.m
//  TableViewInsideCell
//
//  Created by Bushra on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@implementation TableViewController
@synthesize tableViewCellWithTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.frame = CGRectMake(0, 0, 50, 10);
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    [tableViewCellWithTableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *one = [[[NSDictionary alloc] initWithObjectsAndKeys:@"29 C", @"Temperature High",
                          @"22 C", @"Temperature Low",
                          @"25 C", @"Temperature Current",
                          @"10 meters", @"Altitude",
                          @"12/04/2010", @"Date",
                          @"05:45 PM", @"Time",
                          @"12kph", @"Wind Speed",
                          @"North west", @"Wind Direction", nil] autorelease];
    NSDictionary *two = [[[NSDictionary alloc] initWithObjectsAndKeys:@"29 C", @"Temperature High",
                          @"22 C", @"Temperature Low",
                          @"25 C", @"Temperature Current",
                          @"10 meters", @"Altitude",
                          @"12/04/2010", @"Date",
                          @"05:45 PM", @"Time",
                          @"12kph", @"Wind Speed",
                          @"North west", @"Wind Direction", nil] autorelease];

    NSDictionary *three = [[[NSDictionary alloc] initWithObjectsAndKeys:@"29 C", @"Temperature High",
                            @"22 C", @"Temperature Low",
                            @"25 C", @"Temperature Current",
                            @"10 meters", @"Altitude",
                            @"12/04/2010", @"Date",
                            @"05:45 PM", @"Time",
                            @"12kph", @"Wind Speed",
                            @"North west", @"Wind Direction", nil] autorelease];

    NSDictionary *four = [[[NSDictionary alloc] initWithObjectsAndKeys:@"29 C", @"Temperature High",
                           @"22 C", @"Temperature Low",
                           @"25 C", @"Temperature Current",
                           @"10 meters", @"Altitude",
                           @"12/04/2010", @"Date",
                           @"05:45 PM", @"Time",
                           @"12kph", @"Wind Speed",
                           @"North west", @"Wind Direction", nil] autorelease];

    dataArray = [[NSArray alloc] initWithObjects:one, two, three, four, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellWithTableView";
    
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        tableViewCellWithTableView.data = [dataArray objectAtIndex:indexPath.row];
        tableViewCellWithTableView.tableViewInsideCell.allowsSelection = NO;
        cell = tableViewCellWithTableView;
        [cell setNeedsDisplay];
    }
    
    // Configure the cell...
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

@end
