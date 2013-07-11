//
//  CollectionViewTableCell.h
//  IA
//
//  Created by Hunter on 7/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveImageView.h"

@interface CollectionViewTableCell : UITableViewCell


@property (nonatomic, weak) IBOutlet ArchiveImageView *archiveImageView;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *collectionBanner;

@end
