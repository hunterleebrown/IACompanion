//
//  ArchiveBookPageTextViewController.h
//  IA
//
//  Created by Hunter on 2/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFile.h"
#import "AsyncTextView.h"
#import "ArchiveBookPageViewController.h"

@interface ArchiveBookPageTextViewController : ArchiveBookPageViewController


- (void) getPageWithFile:(ArchiveFile *)file withIndex:(int)index fontSize:(int)size;

@property (nonatomic, weak) IBOutlet AsyncTextView *bodyTextView;
@property (nonatomic, weak) IBOutlet UILabel *pageNumber;
//@property (nonatomic) int index;
@property (nonatomic) int fontSize;
@property (nonatomic, retain) ArchiveFile *file;
@property (nonatomic, retain) IBOutlet UIButton *fontSizePlusButton;
@property (nonatomic, retain) IBOutlet UIButton *fontSizeMinusButton;


- (IBAction)fontSizeChange:(id)sender;

@end
