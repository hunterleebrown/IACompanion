//
//  MeidaFileCell.m
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MediaFileCell.h"

@implementation MediaFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.backView.layer setCornerRadius:10.0f];
//    [self.backView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
//    [self.backView.layer setBorderWidth:1.0];

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
