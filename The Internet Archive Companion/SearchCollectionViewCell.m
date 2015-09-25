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
#define TITLE_FONT  [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]//[UIFont systemFontOfSize:14]
#define CREATOR_FONT [UIFont systemFontOfSize:12]
#define DETAILS_FONT [UIFont systemFontOfSize:12]


@interface SearchCollectionViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet UIView *paddedView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;


//@property (nonatomic, weak) IBOutlet UIView *gradientHolderView;

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
    

    NSInteger orientationDivisor = UIInterfaceOrientationIsLandscape(orientation) && collectionView.bounds.size.width == [UIScreen mainScreen].bounds.size.width ? 3 : 2;

    CGFloat divisor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? orientationDivisor : UIInterfaceOrientationIsLandscape(orientation) && collectionView.bounds.size.width == [UIScreen mainScreen].bounds.size.width ? 2 : 1;
    CGFloat padding = 15;
    
    CGFloat width = ceil((collectionView.bounds.size.width / divisor) - padding);


    CGSize labelTextSize = [[SearchCollectionViewCell titleAttributedString:doc.title] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    CGSize detailsSize = [[SearchCollectionViewCell detailsAttributedString:[StringUtils stringByStrippingHTML:doc.details]] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size;

    
    NSString *creatorName = [SearchCollectionViewCell creatorText:doc];

    CGFloat height = labelTextSize.height + 15; //padding

    height += [creatorName isEqualToString:@""] ? 0 : CREATOR_FONT.lineHeight + 20;
    height += ICONOCHIVE_FONT.lineHeight;
    
    height += detailsSize.height > DETAILS_FONT.lineHeight * 3 ? DETAILS_FONT.lineHeight * 3 : detailsSize.height;
//    height += detailsSize.height > 0 ? 10: 0;

    CGFloat imageHeight = style == CollectionViewCellStyleCollection ? 60 : 100; //[[self class] imageHeightFromWidth:width];
    height += imageHeight;

    height += padding; //top and bottom padding


    if(layoutStyle == CellLayoutStyleCompact)
    {
        width = collectionView.bounds.size.width - 20.0f;
        return CGSizeMake(width, [SearchCollectionViewCell compactHeightForDoc:doc width:width]);
    }

    height += 15;

    
    return CGSizeMake(width, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 132 : 142);
    
}

+ (CGFloat)imageHeightFromWidth:(CGFloat)width
{
    return ceil(width * 0.33);
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

    [self.titleLabel setText:archiveSearchDoc.title];

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

    if(self.collectionCellStyle == CollectionViewCellStyleItem)
    {
    
//        UIColor *topColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.00];
//        UIColor *upperMiddleColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.25];
//        UIColor *middleColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.55];
//        UIColor *bottomColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.85];
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.bounds;
//        gradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor,(id)topColor.CGColor, (id)topColor.CGColor, middleColor.CGColor, bottomColor.CGColor, bottomColor.CGColor, nil];
//        [self.gradientHolderView.layer insertSublayer:gradient atIndex:0];
//        
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
   
    CGFloat imageHeight = self.collectionCellStyle == CollectionViewCellStyleCollection ? 60 : [[self class] imageHeightFromWidth:self.bounds.size.width];
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
    

//    [self.archiveImageView setNeedsUpdateConstraints];
//
//    
//    self.imageViewHeightConstraint.constant = imageHeight;
//    self.imageViewWidthConstraint.constant = imageWidth;
//    



    
//    self.layer.cornerRadius = 5;
    //    self.layer.masksToBounds = YES;

    switch (self.collectionCellStyle) {
        case CollectionViewCellStyleCollection:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.creator setTextColor:[UIColor whiteColor]];
            [self.detailsLabel setTextColor:[UIColor whiteColor]];

            [self setBackgroundColor:[COLLECTION_BACKGROUND_COLOR colorWithAlphaComponent:0.85]];

            [self.typeLabel setTextColor:[UIColor whiteColor]];
            [self.countLabel setTextColor:[UIColor whiteColor]];

//            self.archiveImageView.layer.cornerRadius = imageWidth / 2;
//            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            self.dateLabel.hidden = YES;
            
            
            break;
        case CollectionViewCellStyleItem:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.detailsLabel setTextColor:[UIColor lightTextColor]];

            [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.85]];

            [self.creator setTextColor:[UIColor whiteColor]];
            [self.countLabel setTextColor:[UIColor whiteColor]];

            self.archiveImageView.layer.cornerRadius = 0;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.archiveImageView setClipsToBounds:YES];
            
//            [self.archiveImageView setBackgroundColor:[UIColor whiteColor]];

            [self.dateLabel setTextColor:[UIColor whiteColor]];
//            self.imageViewWidthConstraint.constant = 100;

            
            
            break;
    }
    
    [self.archiveImageView layoutIfNeeded];
    [self.creator layoutIfNeeded];
    [self.typeLabel layoutIfNeeded];
    [self.dateLabel layoutIfNeeded];
    [self.countLabel layoutIfNeeded];

    [self.archiveImageView setClipsToBounds:YES];
    if(self.archiveImageView.archiveImage.downloaded)
    {
        [self.archiveImageView setBackgroundColor:[UIColor whiteColor]];
    }
    
}


- (void)handleTapWithDesitnationViewController:(UIViewController *)destinationController presentingController:(UIViewController *)presentingViewController collectionView:(UICollectionView *)collectionView
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || self.archiveSearchDoc.type == MediaTypeCollection) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[self.archiveImageView.image copy]];
        [img setBackgroundColor:[UIColor whiteColor]];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        
        CGRect point = [presentingViewController.view convertRect:self.archiveImageView.bounds fromView:self.archiveImageView];
        [img setFrame:point];
        
        [presentingViewController.view addSubview:img];
        
        [UIView animateWithDuration:0.33 animations:^{
            [img setFrame:CGRectMake(0, 0, presentingViewController.view.bounds.size.width, presentingViewController.view.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            [presentingViewController.navigationController pushViewController:destinationController animated:NO];
            [img removeFromSuperview];
            
        }];
        
        
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:destinationController];
        [pop presentPopoverFromRect:self.frame inView:collectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}

@end
