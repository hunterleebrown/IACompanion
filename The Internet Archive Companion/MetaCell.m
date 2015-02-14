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

static CGFloat padding = 10.0f;

@synthesize titleLabel, valueLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 5, round(self.contentView.bounds.size.width * 0.5) - (2 * padding), self.contentView.bounds.size.height)];
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(round(self.contentView.bounds.size.width * 0.5) - 20, 5, round(self.contentView.bounds.size.width * 0.5) - 20, self.bounds.size.height)];
        [titleLabel setNumberOfLines:0];
        [valueLabel setNumberOfLines:0];

        [titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:12]];
        [valueLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:12]];
        
        [titleLabel setMinimumScaleFactor:0.25];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];

        [valueLabel setMinimumScaleFactor:0.25];
        [valueLabel setLineBreakMode:NSLineBreakByWordWrapping];

        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:valueLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];


    CGRect titRect = self.titleLabel.frame;
    titRect.size.height = [self heightForLabel:self.titleLabel];
    titRect.size.width = round(self.bounds.size.width * 0.5) - (2 * padding);
    titRect.origin.x = padding;
    self.titleLabel.frame = titRect;

    CGRect valRect = self.valueLabel.frame;
    valRect.size.height = [self heightForLabel:self.valueLabel];
    valRect.size.width = round(self.bounds.size.width * 0.5) - (2 *padding);
    valRect.origin.x = titRect.origin.x + titRect.size.width + padding;

    self.valueLabel.frame = valRect;



//    for(UIView *view in self.contentView.subviews)
//    {
//        view.layer.borderColor = [UIColor redColor].CGColor;
//        view.layer.borderWidth = 1.0;
//    }


}


- (CGFloat) heightForLabel:(UILabel *)lab
{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:lab.text
                                                                         attributes:@{NSFontAttributeName: [UIFont  fontWithName:@"AmericanTypewriter" size:10]}];

    CGRect rect = [attributedText boundingRectWithSize:(CGSize){round(self.bounds.size.width * 0.5), CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context: nil];



    return rect.size.height + padding;
}

- (void) setTitle:(NSString *)ts setValue:(NSString *)value{
    [titleLabel setText:ts];
    [valueLabel setText:value];

    [self setNeedsLayout];
}

+ (CGFloat) heightForValue:(NSString *)value forWidth:(CGFloat)width{

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:value
                                                                         attributes:@{NSFontAttributeName: [UIFont  fontWithName:@"AmericanTypewriter" size:10]}];

    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];

    return rect.size.height + (padding * 2);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
}

@end
