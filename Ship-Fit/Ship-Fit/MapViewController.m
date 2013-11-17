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
    MKPolyline* path;
    BOOL drawPathisOn;
    NSDictionary* weatherJSON;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //source http://www.appcoda.com/ios-programming-101-drop-a-pin-on-map-with-mapkit-api/
    self.mapView.delegate = self;
    
    drawPathisOn = FALSE;
    
    //check for bottom layout guide and adjust up the bottom alignment
    
    //create ios 5 ipad layout with no autolayout
    
    //outlet collections, or just name them the same
    
    //use AFNetworking APHTTPequestOperationManager to get navionics (serverside api calls) instead of using NSURL directly
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    // set up your observers
    
    [_shipfit addObserver:self
               forKeyPath:@"latitude"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"longitude"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"knots"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"compassDegrees"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"compassDirection"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    [_shipfit addObserver:self
               forKeyPath:@"weatherJSON"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    if ( [keyPath isEqualToString:@"latitude" ] )
    {
        self.latLabel.text = [NSString stringWithFormat:@"Lat: %.4f" , _shipfit.latitude ];
    }
    
    else if ( [keyPath isEqualToString:@"longitude" ] )
    {
        self.longLabel.text = [NSString stringWithFormat:@"Long: %.4f" , _shipfit.longitude ];
    }
    
    else if ( [keyPath isEqualToString:@"knots" ] )
    {
        self.speedLabel = [NSString stringWithFormat:@"Speed: %.4f" , _shipfit.knots ];
    }
    
    else if ( [keyPath isEqualToString:@"compassDegrees" ] )
    {
        self.compDegLabel.text = [NSString stringWithFormat:@"%.2f",_shipfit.compassDegrees ];
    }
    
    else if ( [keyPath isEqualToString:@"compassDirection" ] )
    {
        self.compDirLabel.text = _shipfit.compassDirection;
    }
    else if ( [keyPath isEqualToString:@"weatherJSON" ] )
    {
        weatherJSON = [change objectForKey:NSKeyValueChangeNewKey];
        [self updateWeatherLabels];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateWeatherLabels{
    NSString* temp = [NSString stringWithFormat:@"%@",[[weatherJSON objectForKey:@"currently"] valueForKey:@"temperature"]];
    self.tempLoLabel.text = [NSString stringWithFormat:@"DAMNIT"];
    NSLog(@"%@", temp);
}

//MKMapView protocol----------
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
//    //update pathTraveled to draw on screen
//    CLLocation *location = [[CLLocation alloc] initWithLatitude: userLocation.coordinate.latitude
//                                                      longitude: userLocation.coordinate.longitude];
//    if(pathTraveled==Nil){
//        pathTraveled = [[NSMutableArray alloc] initWithObjects:location, nil];
//    }
//    [pathTraveled addObject:location];
//    
//    [self updatePathOverlay];
    
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
    
    if ( drawPathisOn &&  self.shipfit.gps_count != 0 ){
        path = [MKPolyline polylineWithCoordinates:self.shipfit.gps_head count:self.shipfit.gps_count];
        [self.mapView addOverlay:path];
    }
    
    
}

- (IBAction)togglePathAction:(id)sender {
    if( drawPathisOn ){
        drawPathisOn = FALSE;
        [self removePathOverlay];
    }
    else{
        drawPathisOn = TRUE;
        [self updatePathOverlay];
    }
}

- (void) removePathOverlay{
    [self.mapView removeOverlay:path];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_shipfit removeObserver:self forKeyPath:@"latitude"];
    [_shipfit removeObserver:self forKeyPath:@"longitude"];
    [_shipfit removeObserver:self forKeyPath:@"knots"];
    [_shipfit removeObserver:self forKeyPath:@"compassDegrees"];
    [_shipfit removeObserver:self forKeyPath:@"compassDirection"];
    [_shipfit removeObserver:self forKeyPath:@"weatherJSON"];
}

- (void)viewDidUnload {
    [self setCompDegLabel:nil];
    [self setCompDirLabel:nil];
    [self setTempHighLabel:nil];
    [self setTempLabel:nil];
    [self setTempLoLabel:nil];
    [self setWindLabel:nil];
    [self setWindDirLabel:nil];
    [self setSunLabel:nil];
    [super viewDidUnload];
}
@end
