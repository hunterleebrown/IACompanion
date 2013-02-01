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
        
        
        
        
        
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.cornerRadius = 8; // if you like rounded corners
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        

        
        for (id subview in _detailsView.subviews) {
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                ((UIScrollView *)subview).bounces = NO;
            }
            
            if ([subview isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)subview).hidden = YES;
            }
            
        }
        
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
