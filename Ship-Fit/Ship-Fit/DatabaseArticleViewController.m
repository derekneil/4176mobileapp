//
//  DatabaseArticleViewController.m
//  shipfitCRUD
//
//  Created by hamid on 2013-10-28.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import "DatabaseArticleViewController.h"

@interface DatabaseArticleViewController ()

@end

@implementation DatabaseArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    _txtTitle.text = _currentArticle.title;
    //_txtMainArticle.text = _currentArticle.mainText;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [_wvMainText loadHTMLString:_currentArticle.mainText baseURL:baseURL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
