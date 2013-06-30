//
//  ArchiveImageView.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveImage.h"


@interface ArchiveImageView : UIImageView

@property (nonatomic, strong) ArchiveImage *archiveImage;


- (id)initWithArchiveImage:(ArchiveImage *)image;
- (id)initWithFrame:(CGRect)frame archiveImage:(ArchiveImage *)image;
- (id)initWithUIImage:(UIImage *)image;
- (void)updateImage:(ArchiveImage *)img;

@end
