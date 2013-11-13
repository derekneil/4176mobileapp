
#import "ShipFit.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    ShipFit *_shipfit;
}


- (IBAction)let_er_buck: (id)sender
{
    [_shipfit init_and_run_application];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialized Main Logic and keep reference
    _shipfit = [ [ShipFit alloc] init ];
    
    
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
               forKeyPath:@"magnetic_north"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"magnetic_north_bearing"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"true_north"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
    
    [_shipfit addObserver:self
               forKeyPath:@"true_north_bearing"
                  options:NSKeyValueObservingOptionNew
                  context:nil ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [keyPath isEqualToString:@"latitude" ] )
    {
        self.latitude.text = [NSString stringWithFormat:@"Latitude: %f" , _shipfit.latitude ];
    }
    
    if ( [keyPath isEqualToString:@"longitude" ] )
    {
       self.longitude.text = [NSString stringWithFormat:@"Longitude: %f" , _shipfit.longitude ];
    }
    
    if ( [keyPath isEqualToString:@"knots" ] )
    {
        self.speed.text = [NSString stringWithFormat:@"Speed: %f" , _shipfit.knots ];
    }
    
    if ( [keyPath isEqualToString:@"magnetic_north" ] )
    {
        self.magnetic_north.text = [NSString stringWithFormat:@"Magnetic North: %f" , _shipfit.magnetic_north ];
    }
    
    if ( [keyPath isEqualToString:@"magnetic_north_bearing" ] )
    {
        self.magnetic_north_heading.text = _shipfit.magnetic_north_bearing;
    }
    
    if ( [keyPath isEqualToString:@"true_north" ] )
    {
        self.true_north.text = [NSString stringWithFormat:@"Magnetic North: %f" , _shipfit.true_north ];
    }
    
    if ( [keyPath isEqualToString:@"true_north_bearing" ] )
    {
         self.true_north_heading.text = _shipfit.true_north_bearing;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end