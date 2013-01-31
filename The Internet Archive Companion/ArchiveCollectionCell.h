//
//  ArchiveCollectionCell.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ArchiveCollectionCell : UICollectionViewCell{
    IBOutlet UILabel *_title;


}

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageView;

@end
