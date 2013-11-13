//
//  detailViewController.h
//  SearchBar
//
//  Created by Jander Alves on 2013-11-07.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailViewController.h"

@interface detailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) detailViewController * detailView;
@property (weak, nonatomic) NSString *textFromMainView;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIImage *imageFromMainView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;


@end
