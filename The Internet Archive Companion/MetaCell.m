//
//  MetaCell.m
//  IA
//
//  Created by Hunter Brown on 7/14/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MetaCell.h"

@interface MetaCell ()


@end


@implementation MetaCell
@synthesize titleLabel, valueLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 39)];
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 160, 39)];
        [titleLabel setNumberOfLines:0];
        [valueLabel setNumberOfLines:0];

        [titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:10]];
        [valueLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:10]];
        
        [titleLabel setMinimumScaleFactor:0.25];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];

        [valueLabel setMinimumScaleFactor:0.25];
        [valueLabel setLineBreakMode:NSLineBreakByWordWrapping];

        
        [self addSubview:titleLabel];
        [self addSubview:valueLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
    return self;
}

- (void) setTitle:(NSString *)ts setValue:(NSString *)value{
    [titleLabel setText:ts];
    [valueLabel setText:value];

    CGSize valueSize = [value sizeWithFont:[UIFont  fontWithName:@"AmericanTypewriter" size:10] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:NSLineBreakByWordWrapping];
    [valueLabel setFrame:CGRectMake(valueLabel.frame.origin.x, valueLabel.frame.origin.y, 160, valueSize.height >= 44 ? valueSize.height : 44)];
    
}

+ (float) heightForValue:(NSString *)value {
    CGSize valueSize = [value sizeWithFont:[UIFont  fontWithName:@"AmericanTypewriter" size:10] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:NSLineBreakByWordWrapping];
    
    return valueSize.height + 20;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
}

@end
