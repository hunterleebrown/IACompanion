//
//  ArchivePageViewController.h
//  IA
//
//  Created by Hunter on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivePageTextSizeViewController.h"

@protocol PageFontChangeDelegate <NSObject>

- (void)changeFontSizeOfChildControllers:(int)size;

@end

@interface ArchivePageViewController : UIPageViewController<UIPopoverControllerDelegate, ArchivePageTextSizeDelegate>

@property (nonatomic, strong) UIPopoverController *popper;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *fontButton;
@property (nonatomic) int fontSizeForAll;
@property (nonatomic, strong) id<PageFontChangeDelegate> fontChangeDelegate;

@end
