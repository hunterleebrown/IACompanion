//
//  ArchiveBookPageImageViewController.h
//  IA
//
//  Created by Hunter Brown on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ArchiveBookPageImageViewController : UIViewController



@property (nonatomic, retain) AsyncImageView *aSyncImageView;

- (id) initWithZipFileLocation:(NSString *)zipFile withIdentifier:(NSString *)identifier withIndex:(int)index;

@end
