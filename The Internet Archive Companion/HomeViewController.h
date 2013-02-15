//
//  HomeViewController.h
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchivePlayerViewController.h"
#import "HomeCombinedViewController.h"

@interface HomeViewController : UIViewController

@property (nonatomic, retain) UINavigationController *contentController;
@property (nonatomic, retain) ArchivePlayerViewController *playerController;

@end
