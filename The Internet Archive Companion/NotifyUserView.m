//
//  NotifyUserView.m
//  IA
//
//  Created by Hunter on 3/8/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "NotifyUserView.h"

@interface NotifyUserView ()


@end

@implementation NotifyUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)dismiss:(id)sender
{
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];

}

- (void)show
{
    self.hidden = NO;

    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 1.0;
    }];

}
@end
