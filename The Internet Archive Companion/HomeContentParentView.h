//
//  HomeContentParentView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/10/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContentTableView.h"
#import "HomeNavTableView.h"




@interface HomeContentParentView : UIView<UIWebViewDelegate, HomeNavTouchDelegate, UIScrollViewDelegate, HomeContentScrollingDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet HomeContentTableView *homeContentTableView;
@property (weak, nonatomic) IBOutlet UIWebView *homeContentDescriptionView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton;
@property (weak, nonatomic) IBOutlet UIBarItem *toolBarTitle;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionShadow;
@property (weak, nonatomic) IBOutlet UISearchBar *aSearchBar;

@property (weak, nonatomic) IBOutlet UIImageView *iASplashImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchButtons;

@property (weak, nonatomic) IBOutlet UIView *searchButtonHolder;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showListButton;

- (IBAction)toggleDetails:(id)sender;
- (void) hideSplashView;


@end
