//
//  HomeCombinedViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContentParentView.h"
#import "HomeNavTableView.h"
#import "MoreInfoView.h"
@interface HomeCombinedViewController : UIViewController





@property (nonatomic, weak) IBOutlet HomeContentParentView *homeContentView;
@property (nonatomic, weak) IBOutlet UIView *homeNavView;
@property (nonatomic, weak) IBOutlet HomeNavTableView *homeNavTableView;
@property (nonatomic, weak) IBOutlet MoreInfoView *moreInfoView;

@property (nonatomic, weak) IBOutlet UIImageView *rightContentShadow;


@property (nonatomic, weak) IBOutlet UIGestureRecognizer *swipeGestureRecognizerLeft;
@property (nonatomic, weak) IBOutlet UIGestureRecognizer *swipeGestureRecognizerRight;

- (IBAction) moveContentViewOver;
- (IBAction) moveContentViewBack;

- (IBAction)toggleContent:(id)sender;

@end
