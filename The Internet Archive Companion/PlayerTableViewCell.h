//
//  PlayerTableViewCell.h
//  IA
//
//  Created by Hunter Brown on 7/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerFile.h"

@interface PlayerTableViewCell : UITableViewCell

@property (nonatomic, strong) PlayerFile *file;
@property (nonatomic, weak) IBOutlet UILabel *fileTitle;
@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *formatLabel;

- (void)setFormat:(NSString *)format;

@end
