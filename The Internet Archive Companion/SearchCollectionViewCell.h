//
//  SearchCollectionViewCell.h
//  IA
//
//  Created by Hunter Brown on 3/6/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"
#import "ArchiveImageView.h"


typedef enum : NSUInteger {
    CollectionViewCellStyleCollection = 0,
    CollectionViewCellStyleItem = 1
} CollectionViewCellStyle;

typedef enum : NSUInteger {
    CellLayoutStyleGrid,
    CellLayoutStyleCompact
} CellLayoutStyle;



@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet ArchiveImageView *archiveImageView;
@property (nonatomic, weak) IBOutlet UILabel *creator;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;


@property (nonatomic, strong) ArchiveSearchDoc *archiveSearchDoc;

@property (nonatomic) CollectionViewCellStyle collectionCellStyle;


+ (NSAttributedString *) titleAttributedString:(NSString *)string;
+ (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation collectionView:(UICollectionView*)collectionView cellLayoutStyle:(CellLayoutStyle)layoutStyle archiveDoc:(ArchiveSearchDoc *)doc;
+ (NSString *)creatorText:(ArchiveSearchDoc *)doc;
+ (CGFloat)compactHeightForDoc:(ArchiveSearchDoc *)doc width:(CGFloat)width;

@end
