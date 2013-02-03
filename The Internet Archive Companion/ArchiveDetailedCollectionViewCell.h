//
//  ArchiveDetailedCollectionViewCell.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ArchiveDetailedCollectionViewCell : UICollectionViewCell {

}

@property IBOutlet UIWebView *detailsView;
@property IBOutlet UILabel *title;
@property IBOutlet UILabel *publisher;
@property IBOutlet UILabel *date;
@property IBOutlet UILabel *from;

@property IBOutlet UILabel *publicDate;
@property IBOutlet UILabel *added;
@property IBOutlet UILabel *subject;


@property IBOutlet AsyncImageView *archiveImageView;

@end
