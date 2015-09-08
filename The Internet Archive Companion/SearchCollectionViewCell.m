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


//static CGFloat compactHeight = 44.0f;
#define TITLE_FONT [UIFont systemFontOfSize:14]
#define CREATOR_FONT [UIFont systemFontOfSize:12]
#define DETAILS_FONT [UIFont systemFontOfSize:12]


@interface SearchCollectionViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *paddedView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;




@end

@implementation SearchCollectionViewCell



+ (NSAttributedString *) titleAttributedString:(NSString *)string
{
    UIFont *font = TITLE_FONT;
    

    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 0.5;
//    para.maximumLineHeight = font.pointSize;
//    para.maximumLineHeight = font.pointSize;

    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : para}];

}

+ (NSAttributedString *) detailsAttributedString:(NSString *)string
{
    UIFont *font = DETAILS_FONT;
    
    
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 1.0;
    para.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : para}];
    
}


+ (CGSize)sizeForOrientation:(UIInterfaceOrientation)orientation collectionView:(UICollectionView*)collectionView cellLayoutStyle:(CellLayoutStyle)layoutStyle archiveDoc:(ArchiveSearchDoc *)doc
{

    CollectionViewCellStyle style = doc.type == MediaTypeCollection ? CollectionViewCellStyleCollection : CollectionViewCellStyleItem;
    

    NSInteger orientationDivisor = UIInterfaceOrientationIsLandscape(orientation) && collectionView.bounds.size.width == [UIScreen mainScreen].bounds.size.width ? 4 : 3;

    CGFloat divisor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? orientationDivisor : UIInterfaceOrientationIsLandscape(orientation) && collectionView.bounds.size.width == [UIScreen mainScreen].bounds.size.width ? 3 : 2;
    CGFloat padding = 15;
    
    CGFloat width = ceil((collectionView.bounds.size.width / divisor) - padding);


    CGSize labelTextSize = [[SearchCollectionViewCell titleAttributedString:doc.title] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    CGSize detailsSize = [[SearchCollectionViewCell detailsAttributedString:[StringUtils stringByStrippingHTML:doc.details]] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    
    NSString *creatorName = [SearchCollectionViewCell creatorText:doc];

    CGFloat height = labelTextSize.height + 15; //padding

    height += [creatorName isEqualToString:@""] ? 0 : CREATOR_FONT.lineHeight;
    height += ICONOCHIVE_FONT.lineHeight;
    
    height += detailsSize.height > DETAILS_FONT.lineHeight * 3 ? DETAILS_FONT.lineHeight * 3 : detailsSize.height;
//    height += detailsSize.height > 0 ? 10: 0;

    CGFloat imageHeight = style == CollectionViewCellStyleCollection ? 60 : ceil(width * 0.66);
    height += imageHeight;

    height += padding; //top and bottom padding


    if(layoutStyle == CellLayoutStyleCompact)
    {
        width = collectionView.bounds.size.width - 20.0f;
        return CGSizeMake(width, [SearchCollectionViewCell compactHeightForDoc:doc width:width]);
    }

    height += 15;

    
    return CGSizeMake(width, height);
    
}

+ (CGFloat)compactHeightForDoc:(ArchiveSearchDoc *)doc width:(CGFloat)width;
{

//    NSAttributedString *titAtt = [SearchCollectionViewCell titleAttributedString:doc.title];
//    CGSize labelTextSize = [titAtt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    CGSize labelTextSize = [[SearchCollectionViewCell titleAttributedString:doc.title] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    
//    CGFloat height = TITLE_FONT.lineHeight + 10;
    CGFloat height = labelTextSize.height + 25;
    
    NSString *creatorName = [SearchCollectionViewCell creatorText:doc];
    CGSize detailsSize = [[SearchCollectionViewCell detailsAttributedString:doc.details] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;


    height += [creatorName isEqualToString:@""] ? 0 : CREATOR_FONT.lineHeight;
    height += ICONOCHIVE_FONT.lineHeight;

    height += detailsSize.height > DETAILS_FONT.lineHeight * 3 ? DETAILS_FONT.lineHeight * 3 : detailsSize.height;

    height += 15;

    return height;
}

- (void)setArchiveSearchDoc:(ArchiveSearchDoc *)archiveSearchDoc
{
    _archiveSearchDoc = archiveSearchDoc;
    self.archiveImageView.archiveImage = archiveSearchDoc.archiveImage;

    [self.titleLabel setAttributedText:[self.class titleAttributedString:archiveSearchDoc.title]];

    [self.creator setText:[self.class creatorText:archiveSearchDoc]];
    [self.creator setFont:CREATOR_FONT];

    self.typeLabel.text = [MediaUtils iconStringFromMediaType:archiveSearchDoc.type];
    [self.typeLabel setTextColor:[MediaUtils colorFromMediaType:archiveSearchDoc.type]];


    if(archiveSearchDoc.type == MediaTypeCollection){
        [self setCollectionCellStyle:CollectionViewCellStyleCollection];
    } else {
        [self setCollectionCellStyle:CollectionViewCellStyleItem];
    }


//    [self.detailsLabel setText:[StringUtils stringByStrippingHTML:self.archiveSearchDoc.details]];
    
    [self.detailsLabel setAttributedText:[self.class detailsAttributedString:[StringUtils stringByStrippingHTML:self.archiveSearchDoc.details]]];
    [self.detailsLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSString *countString = [StringUtils decimalFormatNumberFromInteger:[[archiveSearchDoc.rawDoc objectForKey:@"downloads"] integerValue]];
    NSMutableAttributedString *countAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", VIEWS, countString]];
    [countAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:ICONOCHIVE size:12] range:NSMakeRange(0, VIEWS.length)];
    [countAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(VIEWS.length+1, countString.length)];

    self.countLabel.attributedText = countAtt;

    if([archiveSearchDoc.rawDoc objectForKey:@"publicdate"] == nil){
        [self.dateLabel setHidden:YES];
    } else {
        NSString *date = [StringUtils displayShortDateFromArchiveDateString:[archiveSearchDoc.rawDoc objectForKey:@"publicdate"]];
        [self.dateLabel setText:[NSString stringWithFormat:@"Archived\n%@", date]];
        [self.dateLabel setFont:[UIFont systemFontOfSize:10]];
        [self.dateLabel setHidden:NO];
    }


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


    if(self.bounds.size.height == [self.class compactHeightForDoc:self.archiveSearchDoc width:self.bounds.size.width]) // we're in compact mode
    {
        imageHeight = 0;
        self.archiveImageView.hidden = YES;
//        [self.titleLabel setNumberOfLines:1];
    } else
    {
        self.archiveImageView.hidden = NO;
        [self.titleLabel setNumberOfLines:0];

    }


    self.imageViewHeightConstraint.constant = imageHeight;
    self.imageViewWidthConstraint.constant = imageWidth;
    
    [self.archiveImageView setNeedsUpdateConstraints];



    switch (self.collectionCellStyle) {
        case CollectionViewCellStyleCollection:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.creator setTextColor:[UIColor whiteColor]];
            [self.detailsLabel setTextColor:[UIColor whiteColor]];

            [self setBackgroundColor:COLLECTION_BACKGROUND_COLOR];

            [self.typeLabel setTextColor:[UIColor whiteColor]];
            [self.countLabel setTextColor:[UIColor whiteColor]];

            self.archiveImageView.layer.cornerRadius = imageWidth / 2;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            self.dateLabel.hidden = YES;
            
            break;
        case CollectionViewCellStyleItem:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.detailsLabel setTextColor:[UIColor lightGrayColor]];

            [self setBackgroundColor:[UIColor clearColor]];

            [self.creator setTextColor:[UIColor lightGrayColor]];
            [self.countLabel setTextColor:[UIColor lightGrayColor]];

            self.archiveImageView.layer.cornerRadius = 0;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.archiveImageView setClipsToBounds:YES];

            [self.dateLabel setTextColor:[UIColor lightGrayColor]];
            
            break;
    }
    


    [self.archiveImageView setClipsToBounds:YES];
}

@end
