//
//  MapViewController.m
//  mapApp
//
//  Created by Derek Neil on 2013-10-30.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "MapViewController.h"
#import "Direction.h"
#import "Reachability.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    NSMutableArray* pathTraveled;
//    MKPolyline* path;
    BOOL drawPathisOn;
    NSDictionary* weatherJSON;
    Reachability* reach;
    RMMBTilesSource* offlineSource;
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
	// Do any additional setup after loading the view the first time

    //TODO: restore previous state
    drawPathisOn = FALSE;
    
    //check for bottom layout guide and adjust up the bottom alignment
    
    //only load offline map until internet connection is detected
    offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"Ship-Fit" ofType:@"mbtiles"];
    mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    mapView.delegate = self;
    mapView.zoom = 4;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.adjustTilesForRetinaDisplay = YES; // since tiles aren't designed for retina
    
    //allow lower resolution tiles to be used when zooming in
    mapView.missingTilesDepth = 2;
    
    //insert map below everything else on the storyboard
    [self.view insertSubview:mapView atIndex:0];
    
    //online map will crash app, so it can only be added after internet is detected
    //https://github.com/tonymillion/Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    reach = [Reachability reachabilityWithHostname:@"www.mapbox.com"];
    [reach startNotifier];
    NSLog(@"mapVC Reachability Notifications started");
    
}

//reachability notification method
-(void)reachabilityChanged:(NSNotification*)note{
    reach = [note object];
    if([reach isReachable])
    {
        NSLog(@"mapVC Notification Says Reachable");
        [self LoadOnlineMap];
    }
}

- (void)LoadOnlineMap{
    
    RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithMapID:@"krazyderek.g8dkgmh4"];
    [mapView removeTileSource:offlineSource];
    [mapView addTileSource:onlineSource];
    [mapView addTileSource:offlineSource];
    
    [reach stopNotifier]; //since online map will rely on it's cache once initialized
    NSLog(@"mapVC Reachability Notifications stopped");
}

- (void)viewWillAppear:(BOOL)animated{

    // set up observers
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
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.latLabel.text = [NSString stringWithFormat:@"%.4f" , _shipfit.latitude ];
            [self updatePathOverlay];
        }];
    }
    
    else if ( [keyPath isEqualToString:@"longitude" ] )
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.longLabel.text = [NSString stringWithFormat:@"%.4f" , _shipfit.longitude ];
        }];
    }
    
    else if ( [keyPath isEqualToString:@"knots" ] )
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.speedLabel.text = [NSString stringWithFormat:@"%.4f knots" , _shipfit.knots ];
        }];
    }
    
    else if ( [keyPath isEqualToString:@"compassDegrees" ] )
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.compDegLabel.text = [NSString stringWithFormat:@"%.2f",_shipfit.compassDegrees ];
        }];
    }
    
    else if ( [keyPath isEqualToString:@"compassDirection" ] )
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.compDirLabel.text = _shipfit.compassDirection;
        }];
    }
    else if ( [keyPath isEqualToString:@"weatherJSON" ] )
    {
        //keep these on the value changing thread since it could be a big update
        weatherJSON = [change objectForKey:NSKeyValueChangeNewKey];
//        NSLog(@"%@",weatherJSON);
        [self updateWeatherLabels];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateWeatherLabels{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSDictionary* currently = [weatherJSON objectForKey:@"currently"];
        self.tempLabel.text = [NSString stringWithFormat:@"%@",[currently valueForKey:@"temperature"]];
        self.windLabel.text = [NSString stringWithFormat:@"%@",[currently valueForKey:@"windSpeed"]];
        self.windDirLabel.text = [Direction bearing_String:[[currently valueForKey:@"windBearing"] floatValue]];
        
        NSArray* temp = [[weatherJSON objectForKey:@"daily"] objectForKey:@"data"];
        NSDictionary* today = temp[0];
        self.tempHighLabel.text = [NSString stringWithFormat:@"%@",[today valueForKey:@"temperatureMax"]];
        self.tempLoLabel.text = [NSString stringWithFormat:@"%@",[today valueForKey:@"temperatureMin"]];
        self.sunLabel.text = [NSString stringWithFormat:@"%@",[today valueForKey:@"sunsetTime"]];
        
    }];
}

- (IBAction)zoomToMe:(id)sender {
    [self.mapView setCenterCoordinate:*(_shipfit.gps_head) animated:YES];
}

- (IBAction)zoomChange:(id)sender {
    
    CGPoint point = CGPointMake(self.shipfit.latitude, self.shipfit.longitude);
    
    //get user change
    if(sender == _zoomInButton){
        [self.mapView zoomInToNextNativeZoomAt:point animated:YES];
    }
    else if(sender == _zoomOutButton){
        [self.mapView zoomOutToNextNativeZoomAt:point animated:YES];
    }

}

-(void) updatePathOverlay{
    
    if ( drawPathisOn &&  _shipfit.gps_count != 0 ){
//        path = [MKPolyline polylineWithCoordinates:self.shipfit.gps_head count:self.shipfit.gps_count];
//        [self.mapView addOverlay:path];
        NSLog(@"mapView Path updated shipfit.gps_count->%d",_shipfit.gps_count);
    }
    
}

- (IBAction)togglePathAction:(id)sender {
    if( drawPathisOn ){
        drawPathisOn = FALSE;
//        [self removePathOverlay];
    }
    else{
        drawPathisOn = TRUE;
//        [self updatePathOverlay];
    }
}

- (void) removePathOverlay{
//    [self.mapView removeOverlay:path];
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
