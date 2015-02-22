//
//  MediaFileHeaderCell.m
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MediaFileHeaderCell.h"
#import "MediaUtils.h"

@implementation MediaFileHeaderCell

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


- (void)setTypeLabelIconFromFileTypeString:(NSString *)string
{
    self.sectionHeaderTypeLabel.text = [MediaUtils iconStringFromFormat:[MediaUtils formatFromString:string]];
    [self.sectionHeaderTypeLabel setTextColor:[MediaUtils colorForFileFormat:[MediaUtils formatFromString:string]]];

}

@end
