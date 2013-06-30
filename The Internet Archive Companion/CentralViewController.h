//
//  CentralViewController.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContnetViewController.h"
#import "MainNavViewController.h"

@interface CentralViewController : UIViewController


@property (nonatomic, weak) IBOutlet MainNavViewController *mainNavViewController;
@property (nonatomic, weak) IBOutlet UINavigationController *contentNavController;

@end
