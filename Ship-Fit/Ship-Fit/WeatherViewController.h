
#import <UIKit/UIKit.h>
#import "ShipFit.h"

@interface WeatherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Ref to the mothership
@property (weak, nonatomic) ShipFit* shipfit_ref;

// Ref to labels
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *temperatureCurrent;
@property (weak, nonatomic) IBOutlet UILabel *pressure;
@property (weak, nonatomic) IBOutlet UILabel *cloudCover;
@property (weak, nonatomic) IBOutlet UILabel *precipitation;
@property (weak, nonatomic) IBOutlet UILabel *rainType;


//images
@property UIImageView *wind;
@property UIImageView *condition;
@property UIImageView *pressure;
@property UIImageView *tempImage;




@end
