//
//  detailViewController.m
//  SearchBar
//
//  Created by Jander Alves on 2013-11-07.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "detailViewController.h"

@implementation detailViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    self.details.text = self.textFromMainView;
    self.detailImage.image = self.imageFromMainView;
}


@end
