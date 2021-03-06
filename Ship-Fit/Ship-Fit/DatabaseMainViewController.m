//
//  DatabaseMainViewController.m
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import "DatabaseMainViewController.h"
#import "ARTICLE.h"
#import "DatabaseAccess.h"



@interface DatabaseMainViewController ()

@end

@implementation DatabaseMainViewController




/*

-(void)AddDidCancel:(ARTICLE *)article{
    NSManagedObjectContext *context = self.myManageObjectContext;
    [context deleteObject:article];
    
    [self dismissModalViewControllerAnimated:YES];
}


-(void)AddDidSave{
    NSError *error = Nil;
    
    NSManagedObjectContext *context = self.myManageObjectContext;
    if(![context save:&error]){
        NSLog(@"error %@", error);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
*/

#pragma mark viewcontroller

//used synthesize here because of the custome accessor method for fetchedResultsController
@synthesize fetchedResultsController = _fetchedResultsController;




- (void)viewDidUnload {
    [self setDatabaseSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self createDatabase];
    //[self fillDatabaseFromXMLFile];
    
    
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"errorrr! %@", error);
        abort();
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqualToString:@"segueArticleToView"]) {
        DatabaseArticleViewController *dest = (DatabaseArticleViewController *)[segue destinationViewController];
        //dest.delegate = self;
        
        //get idex of selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //fetech the article object
        ARTICLE *newArticle = (ARTICLE *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        //DatabaseArticleViewController *VC = [[DatabaseArticleViewController alloc] initWithNibName:nil bundle:nil];
        
        
        //make DatabaseArticleViewController your delegate
        //self.delegateSetSearchQueryWord = VC;
        
        
        dest.query = _query;
        
        dest.currentArticle = newArticle;
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



//hide the navigation bar in the main database view, but show it in the article view for the back button
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    _fetchedResultsController = nil;
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"errorrr! %@", error);
        abort();
    }
    [self.tableView reloadData];
    

    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections]count] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    id <NSFetchedResultsSectionInfo> sectInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    
    return [sectInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    //check for iOS 5
    if( [[[UIDevice currentDevice] systemVersion] hasPrefix:@"5"]){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    else{ //assume it's 6 or higher
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    // Configure the cell...
    ARTICLE *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = article.title;
    
    return cell;
}


/*

//Asks the data source for the title of the header of the specified section of the table view.
//source: https://developer.apple.com/library/ios/documentation/uikit/reference/UITableViewDataSource_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/UITableViewDataSource/tableView:titleForHeaderInSection:
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.fetchedResultsController sections]objectAtIndex:section]name];
}

*/

#pragma mark NSFetchedResultsController methods

//------ custome accessor method -----------------
-(NSFetchedResultsController *) fetchedResultsController{
    
    if(_fetchedResultsController !=nil){
        return _fetchedResultsController;
    }
    
    //create a fetch request
    _query = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ARTICLE"
                                              inManagedObjectContext:[self myManageObjectContext]];
    [fetchRequest setEntity:entity];
    
    //how artcles are sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES];
    
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    //use fetchedResultsController to display the result in a table view
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:[self myManageObjectContext]
                                                                     sectionNameKeyPath:@"title" cacheName:Nil];
    
    _fetchedResultsController.delegate = self;
    
    //dismiss keyboard
    [_databaseSearchBar resignFirstResponder];
    _databaseSearchBar.text=@"";
    _query=@"";
    
    return _fetchedResultsController;
}




/*
//NSFetchedResultsControllerDelegate Protocols

 source: https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html
 
*/


//Notifies the receiver that the fetched results controller is about to start processing of one or more changes due to an add, remove, move, or update
-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


//Notifies the receiver that the fetched results controller has completed processing of one or more changes
-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


//Notifies the receiver that a fetched object has been changed due to an add, remove, move, or update
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            ARTICLE *changedCourse = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changedCourse.title;
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}





#pragma mark search

-(void)displayArticles:(NSMutableArray *)arrayOfIndexids term:(NSString *)term{
    
    _query = term;
    
    if ([term isEqualToString:@""]) {
        _fetchedResultsController =nil;
        NSError *error = nil;
        if (![[self fetchedResultsController]performFetch:&error]) {
            NSLog(@"errorrr! %@", error);
            abort();
        }
        
        [self.tableView reloadData];
    }
    else{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ARTICLE" inManagedObjectContext:[self myManageObjectContext]];
        [fetchRequest setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"indexID IN %@",arrayOfIndexids];
        
        [fetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        
        NSArray *fetchedObjects = [[self myManageObjectContext] executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"error in fetching the article!");
        }
        
        NSLog(@"---------result for %@-------------\n\n\n", term);
        
        for (ARTICLE *a in fetchedObjects) {
            NSLog(@"%@\n", a.title);
        }
        
        NSLog(@"---------------------------\n\n\n");
        //Article objects are retrieve. now display them in the tableview using NSFetchedResultsController
        //by changing fetch request
        //https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsController_Class/Reference/Reference.html
        

        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                       ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[self myManageObjectContext]
                                     sectionNameKeyPath:@"title"
                                     cacheName:Nil];
        
        if (![[self fetchedResultsController]performFetch:&error]) {
            NSLog(@"errorrr! %@", error);
            abort();
        }
        
        [self.tableView reloadData];
    }
    
}




-(void)searchTheDatabase:(NSString *)textToSearchFor{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"shipfit_Index.sqlite"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    
    //search the index database for a match
    __block NSMutableArray *matches = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        
        //FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM docs WHERE docs MATCH ?", @"canada*"];
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM docs WHERE docs MATCH ?",
                                  [textToSearchFor stringByAppendingString:(@"*")]];
        
        while ([resultSet next]) {
            [matches addObject:[resultSet stringForColumn:@"name"]];
        }
    }];
    
    
    //send the indexids of the matched artcils to displayArticles to query the main database via core data
    [self displayArticles:(matches) term:(textToSearchFor)];
}


//------SEARCHING CODE--------
//source https://developer.apple.com/LIBRARY/IOS/samplecode/ToolbarSearch/Listings/ToolbarSearch_APLToolbarSearchViewController_m.html

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        [self searchBarTextDidEndEditing:aSearchBar];
        //unfilter articles here
    }
    [self searchTheDatabase:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [self searchBarTextDidEndEditing:aSearchBar];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [aSearchBar resignFirstResponder];
}



#pragma mark database creating and indexing

//run only once. create the index for the database
-(void)createDatabase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    
    //http://www.adevelopingstory.com/blog/2013/04/adding-full-text-search-to-core-data.html
    //NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    basePath = [basePath stringByAppendingPathComponent:@"shipfit_Index.sqlite"];
    
    // Using the FMDatabaseQueue ensures that we don't accidentally talk to our database concurrently from two different threads
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:basePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"CREATE VIRTUAL TABLE IF NOT EXISTS docs USING fts4(name, contents);"];
    }];
    
}



//this method is run once
-(void)fillDatabaseFromXMLFile{
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath] ;
    NSString * sampleXML = [resourcePath stringByAppendingPathComponent:@"sample4.xml"];
    NSError * error;
    
	// find "sample.xml" in our bundle resources
	//NSString *sampleXML = [pathForResource:@"sample2" ofType:@"xml"];
    
    
	NSData *data = [NSData dataWithContentsOfFile:sampleXML];
	
	// create a new SMXMLDocument with the contents of sample.xml
    //NSError *error;
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error) {
        NSLog(@"Error while parsing the document: %@", error);
        return;
    }
    
    
    for (SMXMLElement *rows in [document.root childrenNamed:@"Row"]) {
        NSArray *cell = [rows childrenNamed:(@"Cell")];
        
        int i=0;
        ARTICLE *newArticle = (ARTICLE *)[NSEntityDescription insertNewObjectForEntityForName:@"ARTICLE" inManagedObjectContext:[self myManageObjectContext]];
        
        
        for (SMXMLElement *c in cell) {
            
            NSArray *arr = [c children];
            NSString *str = [(SMXMLElement *)[arr objectAtIndex:(0)] value];
            NSLog(@"%@", str);
            
            
            //title
            if(i==0){
                newArticle.title = str;
            }
            
            
            //maintext
            else if (i==1){
                newArticle.mainText = str;
            }
            
            else if (i==2){
                //if string is not empty add img tag
                if ([str length] != 0){
                    NSString *styleTag = @"<head><link rel='stylesheet' type='text/css' href='mystyle.css'></head>";
                    
                    
                    NSString *imgTag = [NSString stringWithFormat:@"<img src='DB_images/%@%@", str, @"'>"];
                    //newArticle.mainText = [newArticle.mainText stringByAppendingString:(imgTag)]; //cancatinate
                    
                    newArticle.mainText = [[styleTag stringByAppendingString:(newArticle.mainText)]
                                           stringByAppendingString:(imgTag)];
                    
                }
            }
            
            i++;
        }
        
        //save the new article to the database
        NSManagedObjectContext *context = self.myManageObjectContext;
        if(![context save:&error]){
            NSLog(@"error %@", error);
        }
        
    }
    


    
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */




@end
