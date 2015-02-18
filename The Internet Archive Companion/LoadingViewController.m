//
//  LoadingViewController.m
//  IA
//
//  Created by Hunter on 7/28/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "LoadingViewController.h"
#import <QuartzCore/QuartzCore.h>



@interface LoadingViewController ()

@property (nonatomic, strong) UIActivityIndicatorView  *activityIndicatorView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIImageView *archiveLogoView;

@end

@implementation LoadingViewController
@synthesize archiveLogoView, loadingLabel, activityIndicatorView;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    
    self.view.layer.cornerRadius = 10.0;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 2;
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(10, 10);
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowRadius = 5.0;
    

     
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicatorView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21.0)];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.font = [UIFont systemFontOfSize:15.0];
    loadingLabel.text = @"LOADING";
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loadingLabel];
    
    archiveLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ia-button-plain.png"]];
    [self.view addSubview:archiveLogoView];
    
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [archiveLogoView setFrame:CGRectMake(round(self.view.frame.size.width / 2 - (archiveLogoView.frame.size.width / 2)), 5, archiveLogoView.frame.size.width, archiveLogoView.frame.size.height)];
    
    [activityIndicatorView setFrame:CGRectMake(round(archiveLogoView.center.x - (activityIndicatorView.frame.size.width / 2)), archiveLogoView.frame.size.height + 8, activityIndicatorView.frame.size.width, activityIndicatorView.frame.size.height)];
    
    [loadingLabel setFrame:CGRectMake(0, activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 5, loadingLabel.frame.size.width, loadingLabel.frame.size.height)];
}

- (void) startAnimating:(BOOL)shouldAnimate{
    if(shouldAnimate){
        [activityIndicatorView startAnimating];
    } else {
        [activityIndicatorView stopAnimating];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
