//
//  ArchiveDetailedViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/31/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"
#import "ArchiveDataService.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AsyncImageView.h"
#import "ArchiveMetadataTableView.h"
#import "ArchivePlayerViewController.h"
#import "ArchivePageViewController.h"


@interface ArchiveDetailedViewController : UIViewController <UIWebViewDelegate, ArchiveDataServiceDelegate, UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIPopoverControllerDelegate, PageFontChangeDelegate, UIAlertViewDelegate> {
    
    ArchiveDataService *service;
    NSMutableArray *vbrs;
    MPMoviePlayerController *player;
    UIPopoverController *sharePopover;

}

@property (nonatomic, retain) IBOutlet UILabel *docTitle;
@property (nonatomic, retain) ArchiveDetailDoc *doc;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIWebView *description;
@property (nonatomic, retain) IBOutlet UIView *movieView;
@property (nonatomic, assign) IBOutlet AsyncImageView *aSyncImage;

@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel *creator;
@property (nonatomic, retain) IBOutlet UILabel *publisher;
@property (nonatomic, retain) IBOutlet UILabel *added;
@property (nonatomic, retain) IBOutlet UILabel *from;
@property (nonatomic, retain) IBOutlet UILabel *uploader;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *viewCollectionButton;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *viewWebPageButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;


@property (nonatomic, weak) IBOutlet ArchiveMetadataTableView *metadataTableView;
@property (nonatomic, weak) IBOutlet UIButton *addFilesToPlayerButton;

@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UILabel *toolbarTitle;
@property (nonatomic, weak) IBOutlet UIImageView *collectionBanner;

- (IBAction)dismiss;
- (IBAction)openWebPage:(id)sender;
- (IBAction)addFilesToPlayer:(id)sender;

@end
