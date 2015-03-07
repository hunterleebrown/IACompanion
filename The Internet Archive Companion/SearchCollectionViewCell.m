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
#import "StringUtils.h"

@interface SearchCollectionViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *paddedView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;


@end

@implementation SearchCollectionViewCell



+ (CGSize)orientation:(UIInterfaceOrientation)orientation collectionView:(UICollectionView*)collectionView sizeOfCellForArchiveDoc:(ArchiveSearchDoc *)doc{
    
    CollectionViewCellStyle style = doc.type == MediaTypeCollection ? CollectionViewCellStyleCollection : CollectionViewCellStyleItem;
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFont *creatorFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    

    NSInteger orientationDivisor = UIInterfaceOrientationIsLandscape(orientation) ? 4 : 3;

    CGFloat divisor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? orientationDivisor : 2;
    CGFloat padding = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20 : 10;
    
    CGFloat width = ceil((collectionView.bounds.size.width / divisor) - padding);
    
    
    CGSize labelTextSize = [doc.title boundingRectWithSize:CGSizeMake(width - 10, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : font} context:nil].size;

    CGSize creatorSize = [[SearchCollectionViewCell creatorText:doc] boundingRectWithSize:CGSizeMake(width - 10, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : creatorFont} context:nil].size;

    CGFloat height = labelTextSize.height > (3 * font.lineHeight) ? (3 * font.lineHeight) : labelTextSize.height;
    height += creatorSize.height;
    height += ICONOCHIVE_FONT.lineHeight;
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
    [self.creator setText:[self.class creatorText:archiveSearchDoc]];

    self.typeLabel.text = [MediaUtils iconStringFromMediaType:archiveSearchDoc.type];
    [self.typeLabel setTextColor:[MediaUtils colorFromMediaType:archiveSearchDoc.type]];

    if(archiveSearchDoc.type == MediaTypeCollection){
        [self setCollectionCellStyle:CollectionViewCellStyleCollection];
    } else {
        [self setCollectionCellStyle:CollectionViewCellStyleItem];
    }

    [self.countLabel setText:[StringUtils decimalFormatNumberFromInteger:[archiveSearchDoc.rawDoc objectForKey:@"downloads"]]];

}

+ (NSString *)creatorText:(ArchiveSearchDoc *)doc{
    if(doc.creator){
        return [NSString stringWithFormat:@"by %@", doc.creator];
    } else
    {
        return @"";
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
            [self.creator setTextColor:[UIColor whiteColor]];
            [self setBackgroundColor:COLLECTION_BACKGROUND_COLOR];
            
            self.archiveImageView.layer.cornerRadius = imageWidth / 2;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];

            
            break;
        case CollectionViewCellStyleItem:
            [self.titleLabel setTextColor:[UIColor blackColor]];
            //            [self.creator setTextColor:[UIColor whiteColor]];
            [self setBackgroundColor:[UIColor whiteColor]];

            [self.creator setTextColor:[UIColor darkGrayColor]];

            self.archiveImageView.layer.cornerRadius = 0;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.archiveImageView setClipsToBounds:YES];

            
            break;
    }
    


    [self.archiveImageView setClipsToBounds:YES];
}

@end
