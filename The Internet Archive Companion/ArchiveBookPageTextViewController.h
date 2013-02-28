//
//  ArchiveBookPageTextViewController.h
//  IA
//
//  Created by Hunter on 2/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"
#import "ArchiveFile.h"

@interface ArchiveBookPageTextViewController : UIViewController<ArchiveDataServiceDelegate>


- (void) getPageWithFile:(ArchiveFile *)file withIndex:(int)index;

@property (nonatomic, weak) IBOutlet UITextView *bodyTextView;
@property (nonatomic) int index;
@property (nonatomic, retain) ArchiveFile *file;

@end
