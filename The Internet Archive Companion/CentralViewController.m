//
//  CentralViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CentralViewController.h"

@interface CentralViewController ()

@end

@implementation CentralViewController

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contentNavController"]){
        _contentNavController = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"mainNavViewController"]){
        _mainNavViewController = [segue destinationViewController];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
