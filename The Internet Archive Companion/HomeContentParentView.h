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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailsButton;
@property (weak, nonatomic) IBOutlet UIBarItem *toolBarTitle;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionShadow;
@property (weak, nonatomic) IBOutlet UISearchBar *aSearchBar;

@property (weak, nonatomic) IBOutlet UIImageView *iASplashImageView;
@property (weak, nonatomic) IBOutlet UIView *iAHomeSplashView;
@property (weak, nonatomic) IBOutlet UIWebView *iABlogWebView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *searchButtons;

@property (weak, nonatomic) IBOutlet UIView *searchButtonHolder;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showListButton;

@property (weak, nonatomic) IBOutlet UIView *instructionsView;




- (IBAction)toggleDetails:(id)sender;
- (void) hideSplashView;
- (IBAction) showSplashView;
- (IBAction)toggleSplashView:(id)sender;
- (void) hideSearchButtons;
- (IBAction)toggleInstructions:(id)sender;



@end
