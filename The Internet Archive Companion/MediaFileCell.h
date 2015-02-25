//
//  MeidaFileCell.h
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaFileCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *fileTitle;
@property (nonatomic, weak) IBOutlet UILabel *fileName;
@property (nonatomic, weak) IBOutlet UILabel *fileFormat;
@property (nonatomic, weak) IBOutlet UIView *backView;

@property (nonatomic, weak) IBOutlet UILabel *durationLabel;

@end
