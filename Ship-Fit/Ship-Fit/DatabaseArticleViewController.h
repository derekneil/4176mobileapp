//
//  DatabaseArticleViewController.h
//  shipfitCRUD
//
//  Created by hamid on 2013-10-28.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTICLE.h"
#import "DataBaseMainViewController.h"




@interface DatabaseArticleViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
//@property (weak, nonatomic) IBOutlet UITextView *txtMainArticle;

@property (weak, nonatomic) IBOutlet UIWebView *wvMainText;

@property(nonatomic, strong) ARTICLE *currentArticle;

@property (nonatomic, retain) NSString * query;


- (void)setSearchQueryWord:(NSString *)word;


@end
