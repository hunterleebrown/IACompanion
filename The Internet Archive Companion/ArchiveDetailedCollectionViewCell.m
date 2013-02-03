//
//  ArchiveDetailedCollectionViewCell.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDetailedCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation ArchiveDetailedCollectionViewCell

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        
        
        
        
        

        
        

        
        for (id subview in _detailsView.subviews) {
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                ((UIScrollView *)subview).bounces = NO;
            }
            
            if ([subview isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)subview).hidden = YES;
            }
            
        }
        
        
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        [gradient setOpacity:1.0];
        [gradient setBackgroundColor:[[UIColor clearColor] CGColor]];
        gradient.frame = CGRectMake(0, 108, self.frame.size.width, 108);
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [self.contentView.layer insertSublayer:gradient atIndex:2];
        
        
        
        
        
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
