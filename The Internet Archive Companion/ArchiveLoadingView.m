//
//  ArchiveLoadingView.m
//  IA
//
//  Created by Hunter on 7/10/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveLoadingView.h"
#import <QuartzCore/QuartzCore.h>


@interface ArchiveLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView  *activityIndicatorView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIImageView *archiveLogoView;

@end

@implementation ArchiveLoadingView
@synthesize activityIndicatorView, loadingLabel, archiveLogoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, 100)];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.layer.cornerRadius = 20.0;
        
        [self addSubview:activityIndicatorView];
        
        loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21.0)];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.font = [UIFont boldSystemFontOfSize:17.0];
        loadingLabel.text = @"LOADING";
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        archiveLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ia-button-plain.png"]];
        [self addSubview:archiveLogoView];

        
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(10, 10);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 5.0;
        [self addSubview:activityIndicatorView];
        
        loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21.0)];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:15];
        loadingLabel.text = @"LOADING";
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:loadingLabel];
       // [activityIndicatorView startAnimating];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [archiveLogoView setFrame:CGRectMake(round(self.frame.size.width / 2 - (archiveLogoView.frame.size.width / 2)), 5, archiveLogoView.frame.size.width, archiveLogoView.frame.size.height)];
    
    [activityIndicatorView setFrame:CGRectMake(round(self.frame.size.width / 2 - (activityIndicatorView.frame.size.width / 2)), round(self.center.y - round(activityIndicatorView.frame.size.height /2)), activityIndicatorView.frame.size.width, activityIndicatorView.frame.size.height)];
    
     [loadingLabel setFrame:CGRectMake(0, activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 5, loadingLabel.frame.size.width, loadingLabel.frame.size.height)];
}

- (void) startAnimating{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.alpha = 1.0;
    }];
    [activityIndicatorView startAnimating];
}

- (void) stopAnimating {
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    [activityIndicatorView stopAnimating];
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
