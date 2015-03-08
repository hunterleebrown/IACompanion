//
//  ContnetViewController.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"
#import "IAJsonDataService.h"
#import "PopUpView.h"
#import "MetaDataTable.h"
#import "ArchiveImageView.h"

@interface ContentViewController : UIViewController <IADataServiceDelegate, UIWebViewDelegate>



@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *byLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIView *tableHeaderView;
@property (nonatomic, weak) IBOutlet ArchiveImageView *imageView;
@property (nonatomic, strong) UIWebView *archiveDescription;

@property (nonatomic, weak) IBOutlet UIToolbar *itemToolbar;
@property (nonatomic, weak) IBOutlet UIButton *metaDataButton;
@property (nonatomic, weak) IBOutlet UIButton *descriptionButton;
@property (nonatomic, weak) IBOutlet UIButton *folderButton;
@property (nonatomic, weak) IBOutlet UIButton *collectionButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *collectionBarButton;


@property (nonatomic, weak) IBOutlet UIWebView *middleWebView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *middleWebViewHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *upperViewHeight;


@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *listButton;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *mpBarButton;


@property (nonatomic, strong) ArchiveDetailDoc *detDoc;


@property (nonatomic, strong) PopUpView *popUpView;
@property (nonatomic, strong) MetaDataTable *metaDataTable;


@property (nonatomic, weak) IBOutlet UIButton *homeListButton;
@property (nonatomic, weak) IBOutlet UIButton *homeMediaPlayerButton;
@property (nonatomic, weak) IBOutlet UIButton *homeSearchButton;
@property (nonatomic, weak) IBOutlet UIButton *homeFavoritesButton;


@property (nonatomic, weak) IBOutlet UIButton *favoritesButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UIButton *wwwButton;

@property (nonatomic, weak) IBOutlet UIWebView *itemWebView;
@property (nonatomic, strong) NSString *itemImageUrl;
@property (nonatomic) CGFloat itemImageWidth;

@property (nonatomic, weak) IBOutlet UIView *titleHolder;

- (IBAction)showPopUp:(id)sender;
- (IBAction)showSharingActionsSheet:(id)sender;



@end
