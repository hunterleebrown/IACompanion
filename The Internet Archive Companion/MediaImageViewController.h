//
//  MediaImageViewController.h
//  IA
//
//  Created by Hunter Brown on 7/20/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveImageView.h"
@interface MediaImageViewController : UIViewController

@property (nonatomic, strong)  ArchiveImageView *archiveImageView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) ArchiveImage *image;
@end
