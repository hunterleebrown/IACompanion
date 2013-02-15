//
//  ArchivePlayerTableViewCell.h
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFile.h"


@interface ArchivePlayerTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *fileTitle;
@property (nonatomic, weak) ArchiveFile *file;


@end
