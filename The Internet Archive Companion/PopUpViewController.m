//
//  PopUpViewController.m
//  IA
//
//  Created by Hunter on 7/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "PopUpViewController.h"

#import <QuartzCore/QuartzCore.h>

#define RED [UIColor colorWithRed:134.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]


@interface PopUpViewController ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *popTitle;

@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, strong) NSString *alertTitle;;

@end

@implementation PopUpViewController

@synthesize expanded, closeButton, containerView, popTitle, subView, alertMessage, alertTitle;


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
    
    CGPathRef path = CGPathCreateWithRect(self.view.bounds, NULL);
    self.view.layer.shadowPath = path;
    CGPathRelease(path);
    
    expanded = NO;
    
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    UIImage *closeImage = [UIImage imageNamed:@"close-button.png"];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(10, 2, closeImage.size.width, closeImage.size.height)];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [self.view setClipsToBounds:YES];
    
    containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:containerView];
    [containerView setBackgroundColor:[UIColor clearColor]];
    
    popTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [popTitle setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:15]];
    [popTitle setTextAlignment:NSTextAlignmentCenter];
    [popTitle setBackgroundColor:[UIColor clearColor]];
    [popTitle setTextColor:[UIColor whiteColor]];
    [self.view addSubview:popTitle];
 
    
    [containerView setFrame:CGRectMake(5, 44, self.view.frame.size.width, self.view.frame.size.height)];

    
}

- (void) showWithSubView:(UIView *)view title:(NSString *)title message:(NSString *)message {
    expanded = YES;
   // self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.09, 0.09);

    alertTitle = title;
    subView = view;
    alertMessage = message;
    

    
    
}

- (void)dismiss{
    expanded = NO;
    
    /*
    [UIView animateWithDuration:0.33 animations:^{
        [self.view layoutSubviews];
        // self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
        self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
        
    } completion:^(BOOL finished) {
        //[containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }]; */
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [containerView setFrame:CGRectMake(5, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];

    
    //[self.view setFrame:CGRectMake(10, 20, self.view.superview.frame.size.width - 20, self.view.superview.frame.size.height - 44)];



    if(!subView && alertMessage){
        UIFont *messageFont = [UIFont fontWithName:@"AmericanTypewriter" size:15];
        
//        CGSize alertSize = [alertMessage sizeWithFont:messageFont constrainedToSize:containerView.bounds.size lineBreakMode:NSLineBreakByWordWrapping];
        CGSize alertSize = [alertMessage boundingRectWithSize:containerView.bounds.size options:nil attributes:@{NSFontAttributeName: messageFont} context:nil].size;
        
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertSize.width, alertSize.height)];
        [view setFont:messageFont];
        [view setTextAlignment:NSTextAlignmentCenter];
        [view setBackgroundColor:RED];
        
        [view setTextColor:[UIColor whiteColor]];
        [view setNumberOfLines:0];
        [view setText:alertMessage];
        [containerView addSubview:view];
        [view sizeToFit];
        
    } else {
        [containerView addSubview:subView];
        [subView setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        [subView sizeToFit];
        if([subView isKindOfClass:[UIWebView class]]){
            [((UIWebView *)subView) setScalesPageToFit:YES];
        }
        
        
    }
    
    
    popTitle.text = alertTitle;
    
    
    
    
//    CGSize titleSize = [popTitle.text sizeWithFont:popTitle.font];
    CGSize titleSize = [popTitle.text sizeWithAttributes:@{NSFontAttributeName : popTitle.font}];
    [popTitle setFrame:CGRectMake(self.view.center.x - round(titleSize.width/2) - 10, 0, titleSize.width, 44)];
        
    UIView *contentView;
    if(containerView.subviews && containerView.subviews.count > 0) {
        contentView = [containerView.subviews objectAtIndex:0];
        [contentView setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        
        if([contentView isKindOfClass:[UIWebView class]]){
            [((UIWebView *)contentView) setScalesPageToFit:YES];
        }
    }
    
    
    //[super layoutSubviews];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
