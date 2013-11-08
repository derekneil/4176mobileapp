
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (nonatomic, readwrite, weak) IBOutlet UILabel *latitude;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *longitude;

@property (nonatomic, readwrite, weak) IBOutlet UILabel *heading;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *bearing;

@end
