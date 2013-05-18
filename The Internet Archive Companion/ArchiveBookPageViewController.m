//
//  ArchiveBookPageViewController.m
//  IA
//
//  Created by Hunter on 3/1/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveBookPageViewController.h"

@interface ArchiveBookPageViewController ()

@end

@implementation ArchiveBookPageViewController

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
    
    
    if(self.index == 0 || self.index % 2 == 0){
        [self.leftShadow setHidden:YES];
        [self.rightShadow setHidden:NO];
    } else {
        [self.leftShadow setHidden:NO];
        [self.rightShadow setHidden:YES];
    }
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

- (IBAction)popMe:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopPageControllerNotification" object:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
