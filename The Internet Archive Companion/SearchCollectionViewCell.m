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



+ (NSAttributedString *) titleAttributedString:(NSString *)string
{
    UIFont *font = [UIFont systemFontOfSize:17];
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 0;
    para.maximumLineHeight = font.pointSize;
    para.maximumLineHeight = font.pointSize;

    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : para}];

}

+ (CGSize)orientation:(UIInterfaceOrientation)orientation collectionView:(UICollectionView*)collectionView sizeOfCellForArchiveDoc:(ArchiveSearchDoc *)doc{
    
    CollectionViewCellStyle style = doc.type == MediaTypeCollection ? CollectionViewCellStyleCollection : CollectionViewCellStyleItem;
    
    UIFont *font = [UIFont systemFontOfSize:17];
    UIFont *creatorFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    

    NSInteger orientationDivisor = UIInterfaceOrientationIsLandscape(orientation) ? 4 : 3;

    CGFloat divisor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? orientationDivisor : 2;
    //CGFloat padding = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20 : 10;
    CGFloat padding = 10;
    
    CGFloat width = ceil((collectionView.bounds.size.width / divisor) - padding);



    CGSize labelTextSize = [[SearchCollectionViewCell titleAttributedString:doc.title] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    NSString *creatorName = [SearchCollectionViewCell creatorText:doc];
    CGSize creatorSize = [creatorName boundingRectWithSize:CGSizeMake(width - padding, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : creatorFont} context:nil].size;

    CGFloat height = labelTextSize.height + 15; //padding

    height += [creatorName isEqualToString:@""] ? 0 : creatorFont.lineHeight;
    height += ICONOCHIVE_FONT.lineHeight;

    CGFloat imageHeight = style == CollectionViewCellStyleCollection ? 60 : ceil(width * 0.66);
    height += imageHeight;

    height += padding; //top and bottom padding


    return CGSizeMake(width, height);
    
}

- (void)setArchiveSearchDoc:(ArchiveSearchDoc *)archiveSearchDoc
{
    _archiveSearchDoc = archiveSearchDoc;
    self.archiveImageView.archiveImage = archiveSearchDoc.archiveImage;

    [self.titleLabel setAttributedText:[self.class titleAttributedString:archiveSearchDoc.title]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:17]];

    [self.creator setText:[self.class creatorText:archiveSearchDoc]];

    self.typeLabel.text = [MediaUtils iconStringFromMediaType:archiveSearchDoc.type];
    [self.typeLabel setTextColor:[MediaUtils colorFromMediaType:archiveSearchDoc.type]];


    if(archiveSearchDoc.type == MediaTypeCollection){
        [self setCollectionCellStyle:CollectionViewCellStyleCollection];
    } else {
        [self setCollectionCellStyle:CollectionViewCellStyleItem];
    }

//    [self.countLabel setText:[StringUtils decimalFormatNumberFromInteger:[[archiveSearchDoc.rawDoc objectForKey:@"downloads"] integerValue]]];

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
    
    self.imageViewHeightConstraint.constant = imageHeight;
    self.imageViewWidthConstraint.constant = imageWidth;
    
    [self.archiveImageView setNeedsUpdateConstraints];
    
    switch (self.collectionCellStyle) {
        case CollectionViewCellStyleCollection:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.creator setTextColor:[UIColor whiteColor]];
            [self setBackgroundColor:COLLECTION_BACKGROUND_COLOR];

            [self.typeLabel setTextColor:[UIColor whiteColor]];
            [self.countLabel setTextColor:[UIColor whiteColor]];

            self.archiveImageView.layer.cornerRadius = imageWidth / 2;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            self.dateLabel.hidden = YES;
            
            break;
        case CollectionViewCellStyleItem:
            [self.titleLabel setTextColor:[UIColor blackColor]];
            //            [self.creator setTextColor:[UIColor whiteColor]];
            [self setBackgroundColor:[UIColor whiteColor]];

            [self.creator setTextColor:[UIColor darkGrayColor]];
            [self.countLabel setTextColor:[UIColor darkGrayColor]];

            self.archiveImageView.layer.cornerRadius = 0;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.archiveImageView setClipsToBounds:YES];
//            self.dateLabel.hidden = NO;

            [self.dateLabel setTextColor:[UIColor darkGrayColor]];
            
            break;
    }
    


    [self.archiveImageView setClipsToBounds:YES];
}

@end
