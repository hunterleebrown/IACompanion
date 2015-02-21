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
@property (nonatomic, weak) IBOutlet UIView *tableHeaderView;
@property (nonatomic, weak) IBOutlet ArchiveImageView *imageView;
@property (nonatomic, strong) UIWebView *archiveDescription;

@property (nonatomic, weak) IBOutlet UIButton *metaDataButton;
@property (nonatomic, weak) IBOutlet UIButton *descriptionButton;


@property (nonatomic, strong) ArchiveSearchDoc *searchDoc;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *listButton;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *mpBarButton;
@property (nonatomic, strong) IAJsonDataService *service;


@property (nonatomic, strong) ArchiveDetailDoc *detDoc;


@property (nonatomic, strong) PopUpView *popUpView;
@property (nonatomic, strong) MetaDataTable *metaDataTable;


@property (nonatomic, weak) IBOutlet UIButton *homeListButton;
@property (nonatomic, weak) IBOutlet UIButton *homeMediaPlayerButton;
@property (nonatomic, weak) IBOutlet UIButton *homeSearchButton;
@property (nonatomic, weak) IBOutlet UIButton *homeFavoritesButton;

- (IBAction) showPopUp:(id)sender;


@end
