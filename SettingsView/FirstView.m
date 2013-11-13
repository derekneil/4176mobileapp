//
//  FirstView.m
//  SettingsView
//
//  Created by Jander Alves on 2013-11-12.
//  Copyright (c) 2013 Jander Alves. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView

- (void)viewDidLoad
{
    [super viewDidLoad];

 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeTheChange) name:@"theChange" object:nil];
}

- (void)makeTheChange
{
    _speedLabel.hidden = YES;
    //test
}
@end
