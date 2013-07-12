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


@interface ContentViewController : UIViewController <IADataServiceDelegate>


@property (nonatomic, strong) ArchiveSearchDoc *searchDoc;
@property (nonatomic, weak) IBOutlet UILabel *contentTitleLabel;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *listButton;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) IAJsonDataService *service;


@property (nonatomic, strong) PopUpView *popUpView;

@end
