//
//  CollectionViewTableCell.m
//  IA
//
//  Created by Hunter on 7/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CollectionViewTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MediaUtils.h"
#import "FontMapping.h"
#import "StringUtils.h"

@interface CollectionViewTableCell ()


@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic, strong) ArchiveSearchDoc *doc;

@end




@implementation CollectionViewTableCell
@synthesize gradient;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        

    }
    return self;
}

- (void)setTypeLabelStringFromMediaType:(MediaType)type
{
    self.typeLabel.text = [MediaUtils iconStringFromMediaType:type];
    [self.typeLabel setTextColor:[MediaUtils colorFromMediaType:type]];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
//        [self.contentView setBackgroundColor:[UIColor darkGrayColor]];




   }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
//    _archiveImageView.layer.cornerRadius = 10;
//    _archiveImageView.layer.masksToBounds = YES;




    self.paddedView.layer.shadowColor = [[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2] CGColor];
    self.paddedView.layer.shadowOpacity = 0.2;
    self.paddedView.layer.shadowRadius = 1.0;
    self.paddedView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.paddedView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.paddedView.bounds].CGPath;



    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];

    CGRect imageRect = self.archiveImageView.frame;

    switch (self.collectionCellStyle) {
        case CollectionViewTableCellStyleCollection:
            [self.title setTextColor:[UIColor whiteColor]];
            [self.creator setTextColor:[UIColor whiteColor]];
            [self.paddedView setBackgroundColor:COLLECTION_BACKGROUND_COLOR];

            imageRect.size.width = 80;
            self.archiveImageView.frame = imageRect;

            self.archiveImageView.layer.cornerRadius = self.archiveImageView.bounds.size.width / 2;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFill];

            self.paddedView.layer.cornerRadius = 5.0f;
            self.viewsCountLabel.hidden = YES;
            self.viewsIconLabel.hidden = YES;

            [self.typeLabel setTextColor:[UIColor whiteColor]];

            break;

        default:
            [self.title setTextColor:[UIColor darkGrayColor]];
            [self.creator setTextColor:[UIColor darkGrayColor]];
            [self.paddedView setBackgroundColor:[UIColor whiteColor]];

            imageRect.size.width = 80;
            self.archiveImageView.frame = imageRect;

            self.archiveImageView.layer.cornerRadius = 0;
            self.archiveImageView.layer.masksToBounds = YES;
            [self.archiveImageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.archiveImageView setClipsToBounds:YES];


            self.paddedView.layer.cornerRadius = 0.0f;
            self.viewsCountLabel.hidden = NO;
            self.viewsIconLabel.hidden = NO;


            [self setTypeLabelStringFromMediaType:self.doc.type];

            break;
    }


}

- (void)setCollectionCellStyle:(CollectionViewTableCellStyle)collectionCellStyle
{
    _collectionCellStyle = collectionCellStyle;


}

- (void)load:(ArchiveSearchDoc *)doc
{
    _doc = doc;
    self.title.text = doc.title;
    self.archiveImageView.archiveImage = doc.archiveImage;
    self.decription.text = [StringUtils stringByStrippingHTML:doc.details];
    [self setTypeLabelStringFromMediaType:doc.type];

    if(doc.creator){
        [self.creator setText:[NSString stringWithFormat:@"by %@", doc.creator]];
    } else
    {
        [self.creator setText:@""];
    }

    if(doc.type == MediaTypeCollection){
        [self setCollectionCellStyle:CollectionViewTableCellStyleCollection];
    } else {
        [self setCollectionCellStyle:CollectionViewTableCellStyleItem];
    }


    [self.viewsIconLabel setText:VIEWS];

    NSString *count = [doc.rawDoc objectForKey:@"downloads"];
    [self.viewsCountLabel setText:[StringUtils decimalFormatNumberFromInteger:[count integerValue]]];


}


@end
