//
//  ArchivePageViewController.h
//  IA
//
//  Created by Hunter on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivePageTextSizeViewController.h"
#import "ArchiveFile.h"

@protocol PageFontChangeDelegate <NSObject>

- (void)changeFontSizeOfChildControllers:(NSInteger)size;

@end

@interface ArchivePageViewController : UIPageViewController<UIPopoverControllerDelegate, ArchivePageTextSizeDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageFontChangeDelegate>

@property (nonatomic, strong) UIPopoverController *popper;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *fontButton;
@property (nonatomic) NSInteger fontSizeForAll;
@property (nonatomic, strong) id<PageFontChangeDelegate> fontChangeDelegate;


@property (nonatomic, strong) ArchiveFile *bookFile;
@property (nonatomic, strong) NSString *identifier;


@end
