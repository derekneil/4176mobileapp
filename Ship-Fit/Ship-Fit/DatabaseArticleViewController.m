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


- (void)setSearchQueryWord:(NSString *)word{
    _query = word;
}


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
    
    
    //highlight the found query text
    NSString *str = _currentArticle.mainText;
    NSString *q = _query;
    NSString * replaceStr = [@"<span style='color:blue'>" stringByAppendingString:(q)];
    replaceStr = [replaceStr stringByAppendingString:(@"</span>")];
    
    
    str = [str stringByReplacingOccurrencesOfString:_query
                                         withString:replaceStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [_wvMainText loadHTMLString:str baseURL:baseURL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
