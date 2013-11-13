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

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *compDegLabel;
@property (weak, nonatomic) IBOutlet UILabel *compDirLabel;
- (IBAction)zoomToMe:(id)sender;
- (IBAction)toggleLocationOnMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
- (IBAction)zoomChange:(id)sender;
@property (weak, nonatomic) ShipFit* shipfit;

@end
