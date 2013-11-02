//
//  MapViewController.m
//  mapApp
//
//  Created by Derek Neil on 2013-10-30.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "MapViewController.h"

//sample junk
#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController {
    NSMutableArray* pathTraveled;
    MKPolyline* path;
}

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        pathTraveled = [NSMutableArray alloc];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    //source http://www.raywenderlich.com/21365/
//    // 1 specify location
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 39.281516;
//    zoomLocation.longitude= -76.580806;
//    // 2 create the viewRegion with location as argument
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,
//                                                                       0.5*METERS_PER_MILE,  // also needs
//                                                                       0.5*METERS_PER_MILE); // display region
//    // 3 
//    [mapView setRegion:viewRegion animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //source http://www.appcoda.com/ios-programming-101-drop-a-pin-on-map-with-mapkit-api/
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MKMapView protocol----------
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //source http://www.appcoda.com/ios-programming-101-drop-a-pin-on-map-with-mapkit-api/
    //set default view scale around user on load
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    _speedLabel.text = [NSString stringWithFormat:@"%f", userLocation.location.speed];
    _latLabel.text = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    _longLabel.text = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    CLLocation *loc = userLocation.location;
    [pathTraveled addObject:loc];
    
    [self updatePathOverlay];
    
}

- (MKOverlayView *) mapView:(MKMapView*)delMapView viewForOverlay:(id)overlay{
    MKPolylineView* polyLineView = [[MKPolylineView alloc] initWithOverlay:overlay];
    polyLineView.strokeColor = [UIColor blueColor];
    polyLineView.lineWidth = 3.0;
    return polyLineView;
}

//END MKMapView protocol-------

- (IBAction)zoomToMe:(id)sender {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)toggleLocationOnMap:(id)sender {
    mapView.showsUserLocation = !mapView.showsUserLocation;
}

- (IBAction)zoomChange:(id)sender {
    
    //starting source https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/MapKit/MapKit.html#//apple_ref/doc/uid/TP40009497-CH3-SW1
    MKCoordinateRegion theRegion = mapView.region;
    
    //get user change
    double change = 1.5; //assume zooming in
    if(sender == _zoomInButton){
        change = 0.5;
    }
    //change region view on map
    theRegion.span.longitudeDelta *= change;
    theRegion.span.latitudeDelta *= change;
    [mapView setRegion:theRegion animated:YES];

}

-(void) updatePathOverlay{
    int pathpoints = [pathTraveled count];
    CLLocationCoordinate2D coordArray[pathpoints];
    
    //TODO: get pathTraveled into coordArray
    for(int i=0; i<pathpoints; i++){
        CLLocation* loc = [pathTraveled objectAtIndex:i];
        coordArray[i] = loc.coordinate;
    }
    
    path = [MKPolyline polylineWithCoordinates:coordArray count:pathpoints];
    [self.mapView addOverlay:path];
    
}

- (void) removePathOverlay{
    [self.mapView removeOverlay:path];
}

@end
