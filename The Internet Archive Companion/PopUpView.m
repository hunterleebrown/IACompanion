//
//  PopUpView.m
//  IA
//
//  Created by Hunter Brown on 7/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//


#import "PopUpView.h"
#import <QuartzCore/QuartzCore.h>


@interface PopUpView ()

@property (assign) BOOL expanded;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation PopUpView

@synthesize expanded, closeButton, containerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(self.superview.center.x, self.superview.center.y, 2, 2)];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(10, 10);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 5.0;
        
        self.hidden = YES;
        expanded = NO;
        
       //self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:15]];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        [self setClipsToBounds:YES];
      //  self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);

        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:containerView];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)showWithSubView:(UIView *)view{
    [self setHidden:NO];
    expanded = YES;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.09, 0.09);
    [containerView addSubview:view];
    
    
    [view setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [view sizeToFit];
    [UIView animateWithDuration:0.33 animations:^{
        [self layoutSubviews];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        
    }];
    
    
}

- (void)dismiss{
    expanded = NO;
    [UIView animateWithDuration:0.33 animations:^{
        [self layoutSubviews];
       // self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.09, 0.09);

    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    }];
}

- (void) layoutSubviews{

  //  if(expanded){
        [self setFrame:CGRectMake(10, 10, self.superview.frame.size.width - 20, self.superview.frame.size.height - 20)];
  //  } else {
    //    [self setFrame:CGRectMake(self.superview.center.x, self.superview.center.y, 2, 2)];

   // }
    [closeButton setFrame:CGRectMake(self.center.x - 50 - 10, 0, 100, 44)];
    [containerView setFrame:CGRectMake(5, 44, self.frame.size.width - 10, self.frame.size.height - 49)];
    
    [super layoutSubviews];
}



@end
