//
//  AppDelegate.h
//  Ship-Fit
//
//  Created by Derek Neil on 2013-11-12.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipFit.h"
#import "MapViewController.h"
#import "DatabaseMainViewController.h"
#import "WeatherViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Main Application Logic Coordination
@property (strong, nonatomic) ShipFit* shipfit;

//Map
@property (strong, nonatomic) MapViewController* MapVC;
@property (strong, nonatomic) WeatherViewController *WeatherVC;

//Database
@property (strong, nonatomic) DatabaseMainViewController* DatabaseMainVC;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
