
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *tempImage;
@property (weak, nonatomic) IBOutlet UIImageView *windImage;

@property (weak, nonatomic) IBOutlet UIImageView *conditionImage;
@property (weak, nonatomic) IBOutlet UIImageView *pressureImage;

@property (weak, nonatomic) IBOutlet UILabel *precipitation;

@property (weak, nonatomic) IBOutlet UILabel *curTemp;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *windDirection;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressure;


@end


