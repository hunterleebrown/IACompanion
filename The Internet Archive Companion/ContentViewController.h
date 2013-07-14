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
#import "MetaDataTablePopUpView.h"
#import "ArchiveImageView.h"
#import "ArchiveLoadingView.h"

@interface ContentViewController : UIViewController <IADataServiceDelegate>



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
@property (nonatomic, strong) IAJsonDataService *service;




@property (nonatomic, strong) PopUpView *popUpView;
@property (nonatomic, strong) MetaDataTablePopUpView *metaPopUpView;


@end