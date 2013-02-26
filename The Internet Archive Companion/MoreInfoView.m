//
//  MoreInfoView.m
//  IA
//
//  Created by Hunter Brown on 2/26/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MoreInfoView.h"

@implementation MoreInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor yellowColor]];
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

@end
