//
//  TogglesView.m
//  SettingsView
//
//  Created by Jander Alves on 2013-11-11.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "TogglesView.h"
#import "FirstView.h"

@implementation TogglesView{
    
    NSMutableArray *switchStates;
    NSArray *toggleMenu;
    NSMutableArray * switchArray;
}

@synthesize switch1;
@synthesize switch2;
@synthesize switch3;



- (void)viewDidLoad
{
    [super viewDidLoad];
    toggleMenu = [[NSMutableArray alloc]initWithObjects:@"Alerts", @"Speed",@"Wind", nil];
    switchStates = [[NSMutableArray alloc]init];
    int i = 0;
    for (i = 0 ; i < 3 ; i++)
    {
        [switchStates addObject:@"ON"];
    }
    //self.tableView.dataSource = self;
   // self.tableView.Delegate = self;
   //should be changed when functionalities get done
	// Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UISwitch *switch4 = nil;
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        switch4 = [[UISwitch alloc]initWithFrame:CGRectMake(216,0,0,0)];
        switch4.tag = 99;
        [switch4 addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switch4;
        [cell.contentView addSubview:switch4];
        switch4.on = YES;
    }
    else{
        switch4 = [cell.contentView viewWithTag:99];
        switch4.on = YES;
    }
    [switchArray addObject:switch4];
    cell.textLabel.text = [toggleMenu objectAtIndex:indexPath.row];
    NSLog(@"%d",indexPath.row);
    return cell;
}




- (void)switchChange:(UISwitch *)sender
{
    UITableView *view = sender;
    while (![view isKindOfClass:[UITableViewCell class]])
             {
                 view = [view superview];
             }
   UITableViewCell *cell = view;
   NSIndexPath *indexPathForCell = [self->toggleView indexPathForCell:cell];
    

    
    if (indexPathForCell == nil){
        NSLog(@"wrong returner");
    }
    NSLog(@"index path, %d", indexPathForCell.row);
    
    switch (indexPathForCell.row){
        case 0:
            if(sender.on){
                [switchStates replaceObjectAtIndex:(indexPathForCell.row) withObject:@"ON"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"theChange" object:nil];
                break;
            }
            else{
                [switchStates replaceObjectAtIndex:(indexPathForCell.row) withObject:@"OFF"];
                _label1.hidden = true;
                break;
            }
        case 1:
            if (sender.on){
                [switchStates replaceObjectAtIndex:(indexPathForCell.row) withObject:@"ON"];
                _label2.hidden = false;
                break;
            }
            else{
                [switchStates replaceObjectAtIndex:(indexPathForCell.row) withObject:@"OFF"];
                _label2.hidden = true;
                break;
            }
        case 2:
            if (sender.on){
                [switchStates replaceObjectAtIndex:(indexPathForCell.row) withObject:@"ON"];
                _label3.hidden = false;
                break;
            }
            else{
                [switchStates replaceObjectAtIndex:(indexPathForCell.row) withObject:@"OFF"];
                _label3.hidden = true;
                break;
            }
    }
    
}



- (IBAction)defaultButtonPressed:(id)sender {
}

- (IBAction)backButtonPressed:(id)sender;{
    
}
@end

