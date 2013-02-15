//
//  ArchivePlayerTableViewCell.m
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchivePlayerTableViewCell.h"


@implementation ArchivePlayerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
