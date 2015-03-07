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

@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet ArchiveImageView *archiveImageView;

@property (nonatomic, strong) ArchiveSearchDoc *archiveSearchDoc;

+ (CGSize)collectionView:(UICollectionView*)collectionView sizeOfCellForArchiveDoc:(ArchiveSearchDoc *)doc;

@end
