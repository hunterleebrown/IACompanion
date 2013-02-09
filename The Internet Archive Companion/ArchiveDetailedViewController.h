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


@interface ArchiveDetailedViewController : UIViewController <ArchiveDataServiceDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    ArchiveDataService *service;
    NSMutableArray *vbrs;
    MPMoviePlayerController *player;

}

@property (nonatomic, retain) IBOutlet UILabel *docTitle;
@property (nonatomic, retain) ArchiveDetailDoc *doc;
@property (nonatomic, retain) NSString *identifier;
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



@end
