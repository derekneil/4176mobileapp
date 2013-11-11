
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (nonatomic, readwrite, weak) IBOutlet UILabel *latitude;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *longitude;

@property (nonatomic, readwrite, weak) IBOutlet UILabel *true_north;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *magnetic_north;

@property (nonatomic, readwrite, weak) IBOutlet UILabel *true_north_heading;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *magnetic_north_heading;

@property (nonatomic, readwrite, weak) IBOutlet UILabel *speed;


/* Dis-regard this, I can explain why necessary later */
@property (nonatomic, readwrite, weak) IBOutlet UIButton *debug_button;
- (IBAction)let_er_buck:(id)sender;

@end
