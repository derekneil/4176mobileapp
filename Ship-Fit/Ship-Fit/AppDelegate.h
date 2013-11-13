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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ShipFit* shipfit;
@property (strong, nonatomic) MapViewController* MVC;

@end
