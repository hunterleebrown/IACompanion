//
//  MainNavTableViewCell.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MainNavTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface MainNavTableViewCell ()



@end


@implementation MainNavTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    _navImageView.layer.cornerRadius = 5;
    _navImageView.layer.masksToBounds = YES;
}



@end