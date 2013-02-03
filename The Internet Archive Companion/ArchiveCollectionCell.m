//
//  ArchiveCollectionCell.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArchiveCollectionCell

- (id) initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        
        
        
        
        
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.cornerRadius = 8; // if you like rounded corners
        [self.contentView setBackgroundColor:[UIColor whiteColor]];


        CAGradientLayer *gradient = [CAGradientLayer layer];
        [gradient setOpacity:1.0];
        [gradient setBackgroundColor:[[UIColor clearColor] CGColor]];
        gradient.cornerRadius = 8;
        gradient.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [self.contentView.layer insertSublayer:gradient atIndex:1];
        
        

        self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        

        

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
