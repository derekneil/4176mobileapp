//
//  SimViewController.m
//  SettingsView
//
//  Created by Jander Alves on 2013-11-06.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "SimViewController.h"

@interface SimViewController ()
{
    NSArray *menu;
}

@end

@implementation SimViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.Delegate = self;
    
        menu = [[NSMutableArray alloc]initWithObjects:@"Toggles", @"Alerts",@"Units", nil]; //should be changed when functionalities get done
	// Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [menu objectAtIndex:indexPath.row];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Conditionally perform segues, here is an example:
    switch (indexPath.row)
    {
        case 0:
        [self performSegueWithIdentifier:@"segue1" sender:self];
    
        case 1:
    {
        [self performSegueWithIdentifier:@"segue2" sender:self];
    }
}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
