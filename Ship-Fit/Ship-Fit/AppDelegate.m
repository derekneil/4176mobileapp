//
//  AppDelegate.m
//  Ship-Fit
//
//  Created by Derek Neil on 2013-11-12.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    // Override point for customization after application launch.
    
    NSLog(@"alloc and init shipFit");
     _shipfit = [ [ShipFit alloc] init ];
    
    //get ref to tab bar controller
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    
    //get refs for other view controllers contained within tab bar controller
    if (tabController.viewControllers){
        
        //look for view controllers in tab bar views
        for (UIViewController *view2 in tabController.viewControllers) {
            
            //save ref to specific view controllers so we can work with them
            if ([view2 isKindOfClass:[MapViewController class]]){
                _MapVC = (MapViewController *) view2;
            }
            else if ([view2 isKindOfClass:[UINavigationController class]]){
                UINavigationController *navController = (UINavigationController *)view2;
                if ([[navController.viewControllers objectAtIndex:0] isKindOfClass:[DatabaseMainViewController class]]){
                    _DatabaseMainVC = (DatabaseMainViewController *) [navController.viewControllers objectAtIndex:0];
                }
            }
            else if([view2 isKindOfClass:[WeatherViewController class]]){
                _WeatherVC = (WeatherViewController *)view2;
            }
        }
    }
    
    NSLog(@"pass databaseMainVC ref to manageObjectContext");
    _DatabaseMainVC.myManageObjectContext = self.managedObjectContext;
    
    // pass shipfit refence to map
    _MapVC.shipfit = _shipfit;
    
    // pass shipfit reference to weather
    _WeatherVC.shipfit_ref = _shipfit;
    
    [_shipfit init_and_run_application];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//-----------Database CORE DATA requirements--------------
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"shipfitCRUD" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    
    //added---------------------------
    //check if the databases exists on the device, if not it means its the first time the app is running
    //copy the databases preloaded with data from the resources to the device
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"shipfitMainDatabasev1.sqlite"];
    NSURL *storeURL2 = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"shipfit_Index.sqlite"];
    NSURL *storeURL3 = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"shipfitGPS.sqlite"];
    

    //does the file exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        
        //file doesnt exist, its the first time that the app is running
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"shipfitMainDatabasev1" withExtension:@"sqlite"];
        
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    if (![fileManager fileExistsAtPath:[storeURL2 path]]) {
        
        //file doesnt exist, its the first time that the app is running
        NSURL *defaultStoreURL2 = [[NSBundle mainBundle] URLForResource:@"shipfit_Index" withExtension:@"sqlite"];
        
        if (defaultStoreURL2) {
            [fileManager copyItemAtURL:defaultStoreURL2 toURL:storeURL2 error:NULL];
        }
    }
    
    if (![fileManager fileExistsAtPath:[storeURL3 path]]) {
        
        //file doesnt exist, its the first time that the app is running
        NSURL *defaultStoreURL3 = [[NSBundle mainBundle] URLForResource:@"shipfitGPS" withExtension:@"sqlite"];
        
        if (defaultStoreURL3) {
            [fileManager copyItemAtURL:defaultStoreURL3 toURL:storeURL3 error:NULL];
        }
    }
    
    //--------------------------------
    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"shipfitCRUD.sqlite"];
    
    //added
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:dict error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end