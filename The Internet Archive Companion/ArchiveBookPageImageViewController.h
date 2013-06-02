//
//  ArchiveBookPageImageViewController.h
//  IA
//
//  Created by Hunter Brown on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ArchiveBookPageViewController.h"

@interface ArchiveBookPageImageViewController : ArchiveBookPageViewController<UIScrollViewDelegate>



@property (nonatomic, weak) IBOutlet AsyncImageView *aSyncImageView;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *zipFile;
//@property (nonatomic) int index;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, weak) IBOutlet UILabel *pageNumber;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (void) setPageWithServer:(NSString *)server withZipFileLocation:(NSString *)zipFile withFileName:(NSString *)name withIdentifier:(NSString *)identifier withIndex:(int)index;

@end
