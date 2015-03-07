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

@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet ArchiveImageView *archiveImageView;
@property (nonatomic, weak) IBOutlet UILabel *creator;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) ArchiveSearchDoc *archiveSearchDoc;

@property (nonatomic) CollectionViewCellStyle collectionCellStyle;


+ (CGSize)orientation:(UIInterfaceOrientation)orientation collectionView:(UICollectionView*)collectionView sizeOfCellForArchiveDoc:(ArchiveSearchDoc *)doc;
+ (NSString *)creatorText:(ArchiveSearchDoc *)doc;

@end
