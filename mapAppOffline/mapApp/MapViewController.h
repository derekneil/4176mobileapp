//
//  MapViewController.h
//  mapApp
//
//  Created by Derek Neil on 2013-10-30.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>

@interface MapViewController : UIViewController <RMMapViewDelegate>//<MKMapViewDelegate>
//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (weak, nonatomic) IBOutlet RMMapBoxSource *mapBoxSource;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
- (IBAction)zoomToMe:(id)sender;
- (IBAction)toggleLocationOnMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
- (IBAction)zoomChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end
