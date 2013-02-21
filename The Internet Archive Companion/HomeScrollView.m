//
//  HomeScrollView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeScrollView.h"

@implementation HomeScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    [self respositionNav];
    [self.homeContentView.aSearchBar resignFirstResponder];
}

-(void) respositionNav
{
    CGRect frame = self.homeNavView.frame;
    frame.origin = CGPointMake(self.contentOffset.x, 0);
    self.homeNavView.frame = frame;
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
