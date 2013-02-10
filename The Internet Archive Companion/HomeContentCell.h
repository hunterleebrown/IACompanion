//
//  HomeContentCell.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ArchiveSearchDoc.h"

@interface HomeContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *aSyncImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *underlayView;;
@property (nonatomic, retain) ArchiveSearchDoc *doc;

@end
