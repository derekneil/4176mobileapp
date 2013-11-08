//
//  MapViewController.m
//  mapApp
//
//  Created by Derek Neil on 2013-10-30.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    NSMutableArray* pathTraveled;
//    MKPolyline* path;
}

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //source http://www.appcoda.com/ios-programming-101-drop-a-pin-on-map-with-mapkit-api/
    self.mapView.delegate = self;
    
    //check for bottom layout guide and adjust up the bottom alignment
    
    //create ios 5 ipad layout with no autolayout
    
    //outlet collections, or just name them the same
    
    //use AFNetworking APHTTPequestOperationManager to get navionics (serverside api calls) instead of using NSURL directly
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MKMapView protocol----------
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    //source http://www.appcoda.com/ios-programming-101-drop-a-pin-on-map-with-mapkit-api/
//    //set default view scale around user on load
////    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
////    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    
//    _speedLabel.text = [NSString stringWithFormat:@"%f", userLocation.location.speed];
//    _latLabel.text = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
//    _longLabel.text = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
//    
//    //update pathTraveled to draw on screen
//    CLLocation *location = [[CLLocation alloc] initWithLatitude: userLocation.coordinate.latitude
//                                                      longitude: userLocation.coordinate.longitude];
//    if(pathTraveled==Nil){
//        pathTraveled = [[NSMutableArray alloc] initWithObjects:location, nil];
//    }
//    [pathTraveled addObject:location];
//    
//    [self updatePathOverlay];
//    
//}

//- (MKOverlayView *) mapView:(MKMapView*)delMapView viewForOverlay:(id)overlay{
//    MKPolylineView* polyLineView = [[MKPolylineView alloc] initWithOverlay:overlay];
//    polyLineView.strokeColor = [UIColor blueColor];
//    polyLineView.lineWidth = 3.0;
//    return polyLineView;
//}

//END MKMapView protocol-------

- (IBAction)zoomToMe:(id)sender {
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)toggleLocationOnMap:(id)sender {
//    mapView.showsUserLocation = !mapView.showsUserLocation;
}

- (IBAction)zoomChange:(id)sender {
    
    //starting source https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/MapKit/MapKit.html#//apple_ref/doc/uid/TP40009497-CH3-SW1
//    MKCoordinateRegion theRegion = mapView.region;
//    
//    //get user change
//    double change = 1.5; //assume zooming in
//    if(sender == _zoomInButton){
//        change = 0.5;
//    }
//    //change region view on map
//    theRegion.span.longitudeDelta *= change;
//    theRegion.span.latitudeDelta *= change;
//    [mapView setRegion:theRegion animated:YES];

}

-(void) updatePathOverlay{
    int pathpointcount = [pathTraveled count];
    CLLocationCoordinate2D coordArray[pathpointcount];
    
    //TODO: get pathTraveled into coordArray
    for(int i=0; i<pathpointcount; i++){
        coordArray[i] = [[pathTraveled objectAtIndex:i] coordinate];
    }
    
//    path = [MKPolyline polylineWithCoordinates:coordArray count:pathpointcount];
//    [self.mapView addOverlay:path];
    
}

- (void) removePathOverlay{
//    [self.mapView removeOverlay:path];
}

@end
