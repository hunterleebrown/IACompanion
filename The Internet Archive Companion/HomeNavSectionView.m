//
//  HomeNavSectionView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeNavSectionView.h"

@interface HomeNavSectionView()



@end

@implementation HomeNavSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[NSBundle mainBundle] loadNibNamed:@"HomeNavSectionView~ipad" owner:self options:nil];

        } else {
            [[NSBundle mainBundle] loadNibNamed:@"HomeNavSectionView~iphone" owner:self options:nil];
        }
        
        
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        
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
