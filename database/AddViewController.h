//
//  AddViewController.h
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTICLE.h"

@protocol AddDelegate;

@interface AddViewController : UIViewController

@property(nonatomic, weak) id<AddDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property(nonatomic, strong) ARTICLE *currentArticle;

- (IBAction)save:(id)sender;


- (IBAction)cancel:(id)sender;

@end



@protocol AddDelegate

-(void)AddDidSave;
-(void)AddDidCancel:(ARTICLE *)article;

@end






