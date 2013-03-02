//
//  ArchivePageTextSizeViewController.m
//  IA
//
//  Created by Hunter Brown on 3/1/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchivePageTextSizeViewController.h"

@interface ArchivePageTextSizeViewController ()

@end

@implementation ArchivePageTextSizeViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didPressMinusButton:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(changeFontSize:)]){
        [_delegate changeFontSize:-1];
    }

}

- (IBAction)didPressPlusButton:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(changeFontSize:)]){
        [_delegate changeFontSize:+1];
    }
}

@end
