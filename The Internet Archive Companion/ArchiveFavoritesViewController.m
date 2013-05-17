//
//  ArchiveFavoritesViewController.m
//  IA
//
//  Created by Hunter Brown on 5/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveFavoritesViewController.h"

@interface ArchiveFavoritesViewController ()

@end

@implementation ArchiveFavoritesViewController

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

- (void) viewDidAppear:(BOOL)animated{
  //  [_toolbar setBackgroundImage:[UIImage imageNamed:@"mediabar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

}


- (IBAction)toggle:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleFavoritesNotification" object:nil];
}

@end
