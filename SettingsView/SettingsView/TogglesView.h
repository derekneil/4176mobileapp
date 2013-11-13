//
//  TogglesView.h
//  SettingsView
//
//  Created by Jander Alves on 2013-11-11.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface TogglesView : UIViewController
{
    IBOutlet UITableView * toggleView;
}

@property (weak, nonatomic) UITableView *mainView;
@property UIButton *backButton;
@property UIButton *defaultButton;

@property UITableViewCell *cell1;
@property UITableViewCell *cell2;
@property UITableViewCell *cell3;

@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;



@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label1;

- (IBAction)switch1Action:(id)sender;
- (IBAction)switch2Action:(id)sender;
- (IBAction)switch3Action:(id)sender;

- (IBAction)defaultButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;




@end
