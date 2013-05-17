//
//  MediaToolBar.m
//  IA
//
//  Created by Hunter Brown on 5/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MediaToolBar.h"

@implementation MediaToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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


- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] set]; // or clearColor etc
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
}


@end
