//
//  SearchCollectionViewCell.m
//  IA
//
//  Created by Hunter Brown on 3/6/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@interface SearchCollectionViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *paddedView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;


@end

@implementation SearchCollectionViewCell



+ (CGSize)collectionView:(UICollectionView*)collectionView sizeOfCellForArchiveDoc:(ArchiveSearchDoc *)doc{
    CGFloat width = ceil((collectionView.bounds.size.width / 2) - 10);
    CGSize labelTextSize = [doc.title boundingRectWithSize:CGSizeMake(width - 10, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    
    CGFloat height = labelTextSize.height;
    height += 10;
    
    CGFloat imageHeight = width * 0.66;
    height += imageHeight;
    
    return CGSizeMake(width, height);
    
}

- (void)setArchiveSearchDoc:(ArchiveSearchDoc *)archiveSearchDoc
{
    _archiveSearchDoc = archiveSearchDoc;
    self.archiveImageView.archiveImage = archiveSearchDoc.archiveImage;
    [self.titleLabel setText:archiveSearchDoc.title];


}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageHeight = self.bounds.size.width * 0.66;
    self.imageViewHeightConstraint.constant = imageHeight;
    [self.archiveImageView setNeedsUpdateConstraints];

    [self.archiveImageView setClipsToBounds:YES];
}

@end
