//
//  MainViewController.m
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import "MainViewController.h"
#import "ARTICLE.h"


@interface MainViewController ()

@end

@implementation MainViewController


//used synthesize here because of the custome accessor method for fetchedResultsController
@synthesize fetchedResultsController = _fetchedResultsController;


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




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqualToString:@"addArticle"]) {
        AddViewController *acvc = (AddViewController *)[segue destinationViewController];
        acvc.delegate = self;
        
        ARTICLE *newArticle = (ARTICLE *)[NSEntityDescription insertNewObjectForEntityForName:@"ARTICLE" inManagedObjectContext:[self myManageObjectContext]];
        
        acvc.currentArticle = newArticle;
    }
    
    else if ([[segue identifier]isEqualToString:@"segueArticleToView"]) {
        ViewArticleViewController *dest = (ViewArticleViewController *)[segue destinationViewController];
        //dest.delegate = self;
        
        //get idex of selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //fetech the article object
        ARTICLE *newArticle = (ARTICLE *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"errorrr! %@", error);
        abort();
    }
    
    //[self createDatabase];
    //[self fillDatabaseFromXMLFile];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections]count] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    id <NSFetchedResultsSectionInfo> sectInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    
    return [sectInfo numberOfObjects];
}


//------ custome accessor method -----------------
-(NSFetchedResultsController *) fetchedResultsController{
    if(_fetchedResultsController !=nil){
        return _fetchedResultsController;
    }
    
    //create a fetch request
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
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[self myManageObjectContext] sectionNameKeyPath:@"title" cacheName:Nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (IBAction)btnTest:(id)sender {
    [self searchTheDatabase:(@"derek")];
}


-(void)searchTheDatabase:(NSString *)textToSearchFor{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"shipfit_Index.sqlite"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    

    __block NSMutableArray *matches = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {

        //FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM docs WHERE docs MATCH ?", @"canada*"];
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM docs WHERE docs MATCH ?",
                                  [textToSearchFor stringByAppendingString:(@"*")]];
        
        while ([resultSet next]) {
            [matches addObject:[resultSet stringForColumn:@"name"]];
        }
    }];
    
    NSLog(@"array: %@", matches);
}



-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}






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






//-------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ARTICLE *article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = article.title;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.fetchedResultsController sections]objectAtIndex:section]name];
}



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
                    
                    
                    NSString *imgTag = [NSString stringWithFormat:@"<img src='%@%@", str, @"'>"];
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
