//
//  AddViewController.m
//  shipfitCRUD
//
//  Created by hamid on 2013-10-19.
//  Copyright (c) 2013 hamid. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

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
    
    
    _titleField.text = [self.currentArticle title];
    _textField.text = [self.currentArticle mainText];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate AddDidCancel:[self currentArticle]];
    
}


-(IBAction)save:(id)sender {
    [self.currentArticle setTitle:_titleField.text];
    [self.currentArticle setMainText:_textField.text];
    
    [self.delegate AddDidSave];
    
    //NSLog(@"saved!");
}



@end
