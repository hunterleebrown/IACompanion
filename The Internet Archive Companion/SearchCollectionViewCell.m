//
//  SearchCollectionViewCell.m
//  IA
//
//  Created by Hunter Brown on 3/6/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "FontMapping.h"
#import "MediaUtils.h"

@interface SearchCollectionViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *paddedView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;


@end

@implementation SearchCollectionViewCell



+ (CGSize)collectionView:(UICollectionView*)collectionView sizeOfCellForArchiveDoc:(ArchiveSearchDoc *)doc{
    
    CollectionViewCellStyle style = doc.type == MediaTypeCollection ? CollectionViewCellStyleCollection : CollectionViewCellStyleItem;
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    CGFloat width = ceil((collectionView.bounds.size.width / 2) - 10);
    CGSize labelTextSize = [doc.title boundingRectWithSize:CGSizeMake(width - 10, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : font} context:nil].size;
    
    CGFloat height = labelTextSize.height > (3 * font.lineHeight) ? (3 * font.lineHeight) : labelTextSize.height;
    height += 10;
    
    CGFloat imageHeight = style == CollectionViewCellStyleCollection ? 60 : ceil(width * 0.66);
    height += imageHeight;
    
    return CGSizeMake(width, height);
    
}

- (void)setArchiveSearchDoc:(ArchiveSearchDoc *)archiveSearchDoc
{
    _archiveSearchDoc = archiveSearchDoc;
    self.archiveImageView.archiveImage = archiveSearchDoc.archiveImage;
    [self.titleLabel setText:archiveSearchDoc.title];

    
    if(archiveSearchDoc.type == MediaTypeCollection){
        [self setCollectionCellStyle:CollectionViewCellStyleCollection];
    } else {
        [self setCollectionCellStyle:CollectionViewCellStyleItem];
    }
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    CGFloat imageHeight = self.collectionCellStyle == CollectionViewCellStyleCollection ? 60 :self.bounds.size.width * 0.66;
    CGFloat imageWidth = self.collectionCellStyle == CollectionViewCellStyleCollection ? 60 : self.bounds.size.width - 10;
    
    self.imageViewHeightConstraint.constant = imageHeight;
    self.imageViewWidthConstraint.constant = imageWidth;
    
    [self.archiveImageView setNeedsUpdateConstraints];
    
    switch (self.collectionCellStyle) {
        case CollectionViewCellStyleCollection:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            //            [self.creator setTextColor:[UIColor whiteColor]];
            [self setBackgroundColor:COLLECTION_BACKGROUND_COLOR];
            
            self.archiveImageView.layer.cornerRadius = imageWidth / 2;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];

            
            break;
        case CollectionViewCellStyleItem:
            [self.titleLabel setTextColor:[UIColor blackColor]];
            //            [self.creator setTextColor:[UIColor whiteColor]];
            [self setBackgroundColor:[UIColor whiteColor]];
            
            self.archiveImageView.layer.cornerRadius = 0;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.archiveImageView setClipsToBounds:YES];

            
            break;
    }
    


    [self.archiveImageView setClipsToBounds:YES];
}

@end
