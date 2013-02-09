//
//  HomeCombinedViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContentTableView.h"

@interface HomeCombinedViewController : UIViewController


@property (nonatomic, assign) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, assign) IBOutlet UITableView *mainNavigationTable;
@property (nonatomic, retain) IBOutlet HomeContentTableView *contentTableView;

@end
