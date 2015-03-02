//
//  MediaFileHeaderCell.h
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaFileHeaderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *sectionHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel *sectionHeaderTypeLabel;
@property (nonatomic, weak) IBOutlet UIButton *sectionPlayAllButton;

- (void)setTypeLabelIconFromFileTypeString:(NSString *)string;


@end
