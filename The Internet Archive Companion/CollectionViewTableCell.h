//
//  CollectionViewTableCell.h
//  IA
//
//  Created by Hunter on 7/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveImageView.h"
#import "ArchiveSearchDoc.h"


typedef enum : NSUInteger {
    CollectionViewTableCellStyleCollection = 0,
    CollectionViewTableCellStyleItem = 1
} CollectionViewTableCellStyle;

@interface CollectionViewTableCell : UITableViewCell


@property (nonatomic, weak) IBOutlet ArchiveImageView *archiveImageView;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *collectionBanner;
@property (nonatomic, weak) IBOutlet UILabel *decription;
@property (nonatomic, weak) IBOutlet UIView *paddedView;

@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsIconLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsCountLabel;

@property (nonatomic, weak) IBOutlet UILabel *creator;
@property (nonatomic) CollectionViewTableCellStyle collectionCellStyle;


- (void)setTypeLabelStringFromMediaType:(MediaType)type;
- (void)load:(ArchiveSearchDoc *)doc;

@end
