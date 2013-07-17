//
//  CollectionViewTableCell.m
//  IA
//
//  Created by Hunter on 7/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CollectionViewTableCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CollectionViewTableCell ()


@property (nonatomic, strong) CAGradientLayer *gradient;

@end




@implementation CollectionViewTableCell
@synthesize gradient;

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
        [self.contentView setBackgroundColor:[UIColor darkGrayColor]];
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
    
    _archiveImageView.layer.cornerRadius = 10;
    _archiveImageView.layer.masksToBounds = YES;
    _archiveImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _archiveImageView.layer.borderWidth = 1.0;
    

}




@end
