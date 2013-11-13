//
//  SimViewController.m
//  SearchBar
//
//  Created by Jander Alves on 2013-11-02.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "SimViewController.h"
#import "detailViewController.h"

@interface SimViewController ()
{
    NSMutableArray *totalObjects;
    NSMutableArray *filteredObjects;
    BOOL isFiltered;
 
}

@end

@implementation SimViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self; //change this to app`s database
    self.searchBar.Delegate = self;
    self.tableView.Delegate = self;
    
    
    totalObjects = [[NSMutableArray alloc]initWithObjects:@"Buying a boat is a big decision that requires research before taking action. When broken down into smaller decisions, though, you'll find it much easier to decide on, shop for and buy a boat that is the best fit for you. ",@"Find a boat show near you using the Boat Show and Events Calendar. Typically, January through April offer the most boat shows per month, but boat shows are offered world-wide all year long.",@"EPIRBs, officially known as Emergency Position Indicating Radiobeacons, are emergency beacons used in maritime distress. They are designed to save your life if you get into trouble by alerting rescue authorities and indicating your location anywhere in the world. EPIRBs are classified into two categories: Category I or Category II.", nil]; //must be filled with database topics
    
  
    isFiltered = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        filteredObjects = [[NSMutableArray alloc]init];
        
        for(NSString *str in totalObjects)
        {
            NSRange stringRange = [str rangeOfString:searchText options:(NSCaseInsensitiveSearch)];
            
            if (stringRange.location != NSNotFound)
            {
                [filteredObjects addObject:str];
            }
        }
        
    }
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if (isFiltered)
    {
        return [filteredObjects count];
    }
    return [totalObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(!isFiltered)
    {
        tableView.hidden = YES;
        cell.textLabel.text = [totalObjects objectAtIndex:indexPath.row];
    }
    else
    {
        tableView.hidden = NO;
        cell.textLabel.text = [filteredObjects objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"smallboat.png"];
    }
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView resignFirstResponder];
}
    
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"segue1" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segue1"]){
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        detailViewController *detailView = (detailViewController *)[segue destinationViewController];
        detailView.textFromMainView = [filteredObjects objectAtIndex:selectedIndexPath.row];
        detailView.imageFromMainView = [UIImage imageNamed:@"smallboat.png"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
