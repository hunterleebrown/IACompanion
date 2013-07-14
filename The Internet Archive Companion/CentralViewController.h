//
//  CentralViewController.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "MainNavViewController.h"

@interface CentralViewController : UIViewController


@property (nonatomic, weak) MainNavViewController *mainNavViewController;
@property (nonatomic, weak) UINavigationController *contentNavController;

@property (nonatomic, weak) IBOutlet UIView *navView;
@property (nonatomic, weak) IBOutlet UIView *contentView;


@end