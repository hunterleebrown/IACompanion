//
//  ArchivePlayerViewController.h
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFile.h"



@interface ArchivePlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *playerTableView;
@property (nonatomic, weak) IBOutlet UIView *playerHolder;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editListButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *hidePlayerButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearButton;


@property (nonatomic, weak) IBOutlet UIBarButtonItem *playPause;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *next;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *previous;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwards;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backwards;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *numberOfFiles;


- (IBAction)doPlayPause:(id)sender;
- (IBAction)doNext:(id)sender;
- (IBAction)doPrevious:(id)sender;
- (IBAction)doForwards:(id)sender;
- (IBAction)doBackwards:(id)sender;




- (IBAction)editList:(id)sender;
- (IBAction)clearList:(id)sender;
- (IBAction)hidePlayer:(id)sender;

@end
