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

- (IBAction)editList:(id)sender;

@end
