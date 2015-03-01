//
//  MainNavTableViewCell.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveImageView.h"

@interface MainNavTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *navCellTitleLabel;
@property (nonatomic, weak) IBOutlet ArchiveImageView *navImageView;
@property (nonatomic, weak) IBOutlet UIView *paddedView;
@property (nonatomic, strong) UILabel *fontLabel;

@end
