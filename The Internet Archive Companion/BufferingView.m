//
//  BufferingView.m
//  IA
//
//  Created by Hunter Brown on 7/18/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "BufferingView.h"
#import <QuartzCore/QuartzCore.h>

@interface BufferingView ()
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic, strong) UILabel *title;

@end

@implementation BufferingView
@synthesize shouldAnimate, title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        shouldAnimate = NO;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 18)];
        [title setFont:[UIFont fontWithName:@"AmericanTypewriter" size:12]];
        [title setTextColor:[UIColor whiteColor]];
        [title setShadowColor:[UIColor darkGrayColor]];
        [title setShadowOffset:CGSizeMake(1, 1)];
        [self addSubview:title];
        [title setText:@"loading"];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextAlignment:NSTextAlignmentCenter];
        
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    [title setFrame:CGRectMake(self.frame.size.width / 2 - 25, 2, 50, 18)];
}

- (void) startAnimating{
    
    [self setHidden:NO];
    shouldAnimate = YES;
    [UIView animateWithDuration:1.0f delay:0.0f options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{ self.backgroundColor = [UIColor orangeColor];
    } completion:^(BOOL finished) {
      //  if(!shouldAnimate){
      //      return;
       // }
    }];
}

- (void) stopAnimating{
   [self setHidden:YES];
    shouldAnimate = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
