//
//  MapViewController.h
//  mapApp
//
//  Created by Derek Neil on 2013-10-30.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShipFit.h"
#import <MapBox/MapBox.h>

@interface MapViewController : UIViewController <RMMapViewDelegate>

@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *compDegLabel;
@property (weak, nonatomic) IBOutlet UILabel *compDirLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLoLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunLabel;

- (IBAction)togglePathAction:(id)sender;
- (IBAction)zoomToMe:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
- (IBAction)zoomChange:(id)sender;

@property (weak, nonatomic) ShipFit* shipfit;

@end
