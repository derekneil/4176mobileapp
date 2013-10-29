//
//  ViewArticleViewController.h
//  shipfitCRUD
//
//  Created by hamid on 2013-10-28.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTICLE.h"


@interface ViewArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtMainArticle;
@property(nonatomic, strong) ARTICLE *currentArticle;

@end
