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
@property (nonatomic, strong) UILabel *popTitle;

@end

@implementation PopUpView

@synthesize expanded, closeButton, containerView, popTitle;

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
        
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        UIImage *closeImage = [UIImage imageNamed:@"x-done.png"];
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [closeButton setFrame:CGRectMake(10, 10, closeImage.size.width, closeImage.size.height)];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        [self setClipsToBounds:YES];

        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:containerView];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        popTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [popTitle setFont:[UIFont fontWithName:@"AmericanTypewriter" size:15]];
        [popTitle setTextAlignment:NSTextAlignmentCenter];
        [popTitle setBackgroundColor:[UIColor clearColor]];
        [popTitle setTextColor:[UIColor whiteColor]];
        [self addSubview:popTitle];
        
        
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


- (void) showWithSubView:(UIView *)view title:(NSString *)title message:(NSString *)message {
    [self setHidden:NO];
    expanded = YES;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.09, 0.09);
    
    if(!view && message){
        UIFont *messageFont = [UIFont fontWithName:@"AmericanTypewriter" size:15];

        
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        [view setFont:messageFont];
        [view setTextAlignment:NSTextAlignmentCenter];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTextColor:[UIColor whiteColor]];
        [view setNumberOfLines:0];
        [view setText:message];
        [containerView addSubview:view];
        [view sizeToFit];
    } else {
        [containerView addSubview:view];
        [view setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        [view sizeToFit];
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        [self layoutSubviews];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
    popTitle.text = title;

    
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
    

    [self setFrame:CGRectMake(10, 20, 320 - 20, 480 - 100)];
 
    
    CGSize titleSize = [popTitle.text sizeWithFont:popTitle.font];
    [popTitle setFrame:CGRectMake(self.center.x - round(titleSize.width/2) - 10, 0, titleSize.width, 44)];
    

    
    [containerView setFrame:CGRectMake(5, 44, self.frame.size.width - 10, self.frame.size.height - 49)];
    
    [super layoutSubviews];
}



@end
