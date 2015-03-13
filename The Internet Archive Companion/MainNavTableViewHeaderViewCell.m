//
//  MainNavTableViewHeaderViewCell.m
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MainNavTableViewHeaderViewCell.h"

@interface MainNavTableViewHeaderViewCell ()
@property (nonatomic, strong) UIView *borderBottom;

@end

@implementation MainNavTableViewHeaderViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.borderBottom = [[UIView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height, self.bounds.size.width - 10, 1)];
        [self.borderBottom setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.borderBottom];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1.0]];

    CGRect bFrame = self.borderBottom.frame;
    bFrame.origin.y = self.bounds.size.height - 1;
    self.borderBottom.frame = bFrame;
    
    [super layoutSubviews];

}


@end
