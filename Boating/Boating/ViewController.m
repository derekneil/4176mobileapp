
#import "ShipFit.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    ShipFit *_shipfit;
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

    /* Run the Application */
    [ _shipfit init_and_run_application ];
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [keyPath isEqualToString:@"latitude" ] )
    {
        // to do
    }
    
    if ( [keyPath isEqualToString:@"longitude" ] )
    {
        // to do
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end