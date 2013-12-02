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
#import "WeatherViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@end

@implementation MapViewController {
    NSMutableArray* pathTraveled;
    RMAnnotation *annotation;
    BOOL drawPathisOn;
    NSDictionary* weatherJSON;
    RMMBTilesSource* offlineSource;
    BOOL pannedMapAway;
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
    pannedMapAway = TRUE;
    
    //check for bottom layout guide and adjust up the bottom alignment
    
    offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"Ship-Fit" ofType:@"mbtiles"];
    
    if (_shipfit.internetAvail==FALSE) {
        
        //only load offline map until internet connection is detected
        mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
        
        // set up internet observer for online map, otherwise it will crash the app when it first loads
        [_shipfit addObserver:self
                   forKeyPath:@"internetAvail"
                      options:NSKeyValueObservingOptionNew
                      context:nil ];
    }
    else{ //internet is available so we can load the online map
        RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithMapID:@"krazyderek.g8dkgmh4"];
        mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineSource];
        
        //then add oceans offline map overlay
        [mapView addTileSource:offlineSource];
    }
    
    mapView.delegate = self;
    mapView.zoom = 4;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.adjustTilesForRetinaDisplay = YES; // since tiles aren't designed for retina
    
    //allow lower resolution tiles to be used when zooming in
    mapView.missingTilesDepth = 2;
    
    mapView.showsUserLocation=TRUE;
    
    [self.mapView zoomingInPivotsAroundCenter];
    
    //insert map below everything else on the storyboard
    [self.view insertSubview:mapView atIndex:0];
}

- (void)loadOnlineMap{
    
    RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithMapID:@"krazyderek.g8dkgmh4"];
    
    //if i just insert, the oceans overlay doesn't dissappear below it's zoom level
    [mapView removeTileSource:offlineSource];
    
    [mapView addTileSource:onlineSource];
    [mapView addTileSource:offlineSource];
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
            if(pannedMapAway==FALSE){
                [self zoomToMe:nil];
            }
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
            self.speedLabel.text = [NSString stringWithFormat:@"%.1f knots" , _shipfit.knots ];
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
        [self updateWeatherLabels];
    }
    else if ( [keyPath isEqualToString:@"internetAvail" ] )
    {
        //this should only fire once, when internet is first avail to app
        [self loadOnlineMap];
        //remove cause online map will work from cache once initialized
        [_shipfit removeObserver:self forKeyPath:@"internetAvail"];
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
        self.tempLabel.text = [NSString stringWithFormat:@"%.f\u00B0C",[WeatherViewController degFtoDegC:[currently valueForKey:@"temperature"]] ];
        self.windLabel.text = [NSString stringWithFormat:@"%.1f KM/H",([[currently valueForKey:@"windSpeed"]floatValue] * 1.609344)];
        self.windDirLabel.text = [Direction bearing_String:[[currently valueForKey:@"windBearing"] floatValue]];
        
        NSArray* temp = [[weatherJSON objectForKey:@"daily"] objectForKey:@"data"];
        NSDictionary* today = temp[0];
        self.tempHighLabel.text = [NSString stringWithFormat:@"%.f\u00B0C",[WeatherViewController degFtoDegC:[today valueForKey:@"temperatureMax"]]];
        self.tempLoLabel.text = [NSString stringWithFormat:@"%.f\u00B0C",[WeatherViewController degFtoDegC:[today valueForKey:@"temperatureMin"]]];
        
        //parse date
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[today valueForKey:@"sunsetTime"] doubleValue] ];
        NSDateComponents *date_components = [[NSCalendar currentCalendar] components: kCFCalendarUnitMinute | kCFCalendarUnitHour fromDate:date ];;
        int hour = [date_components hour];
        NSString* ampm = @"AM";
        
        if (hour==0){
            hour+=12;
        }
        else if (hour == 12 ){
            ampm =@"PM";
        }
        else if (hour > 12) {
            hour -=12;
            ampm =@"PM";
        }
        self.sunLabel.text = [NSString stringWithFormat:@"%d:%ld %@",hour, (long)[date_components minute],ampm ];
    }];
}

- (void)beforeMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction{
    //change location icon
    if(wasUserAction){
        [self.locationButton setImage:[UIImage imageNamed:@"locationinactive.png"] forState:UIControlStateNormal];
        pannedMapAway = TRUE;
    }
}

- (IBAction)zoomToMe:(id)sender {
    
    //change location icon
    [self.locationButton setImage:[UIImage imageNamed:@"location.png"] forState: UIControlStateNormal];
    
    //move map
    [self.mapView setZoom:self.shipfit.zoom atCoordinate:*(_shipfit.gps_head) animated:YES];
    NSLog(@"zoom %d",self.shipfit.zoom);
    
    pannedMapAway = false;
}

- (IBAction)zoomChange:(id)sender {
    
    CGPoint point = [mapView coordinateToPixel:mapView.centerCoordinate];
    
    //get user change
    if(sender == _zoomInButton){
        [self.mapView zoomInToNextNativeZoomAt:point animated:YES];
        if(self.shipfit.zoom <25)
            self.shipfit.zoom++;
        NSLog(@"zoom %d",self.shipfit.zoom);
    }
    else if(sender == _zoomOutButton){
        [self.mapView zoomOutToNextNativeZoomAt:point animated:YES];
        if(self.shipfit.zoom >1)
            self.shipfit.zoom--;
        NSLog(@"zoom %d",self.shipfit.zoom);
    }
    
}

-(void) updatePathOverlay{
    
    if ( drawPathisOn &&  _shipfit.gps_count != 0 ){
        
//        if( annotation==nil ){
        //create annotation layer for map path to be shown on
            annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                                  coordinate:*(self.shipfit.gps_head)
                                                                    andTitle:nil];
            [self.mapView addAnnotation:annotation];
//        }
        
        NSLog(@"mapView Path updated shipfit.gps_count->%d",_shipfit.gps_count);
    }
    
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)thisannotation
{
    if (thisannotation.isUserLocationAnnotation)
        return nil;
    
    RMShape *line = [[RMShape alloc] initWithView:self.mapView];
    
    line.lineWidth = 6.0;
    
    line.lineColor = [UIColor orangeColor];
    
    [line moveToCoordinate:*(self.shipfit.gps_head)];
    
    [line addLineToCoordinate:*(self.shipfit.gps_head+1)];
    
    NSLog(@"mapView Path returning line to draw");
    
    return line;
}

- (IBAction)togglePathAction:(id)sender {
    if( drawPathisOn == TRUE ){
        drawPathisOn = FALSE;
        //change path button icon
        [self.pathButton setImage:[UIImage imageNamed:@"pathinactive.png"] forState: UIControlStateNormal];
//        [self removePathOverlay];
    }
    else if (drawPathisOn == FALSE){
        drawPathisOn = TRUE;
        //change path button icon
        [self.pathButton setImage:[UIImage imageNamed:@"path.png"] forState: UIControlStateNormal];
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
