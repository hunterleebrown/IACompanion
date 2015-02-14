//
//  ArchivePageTextSizeViewController.h
//  IA
//
//  Created by Hunter Brown on 3/1/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArchivePageTextSizeDelegate <NSObject>

- (void) changeFontSize:(NSInteger)size;


@end

@interface ArchivePageTextSizeViewController : UIViewController


@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *plusButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *minusButton;
@property (nonatomic, strong) UIPopoverController *myPop;
@property (nonatomic, strong) id<ArchivePageTextSizeDelegate> delegate;

- (IBAction)didPressMinusButton:(id)sender;
- (IBAction)didPressPlusButton:(id)sender;

@end
