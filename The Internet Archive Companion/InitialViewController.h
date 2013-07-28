//
//  RootViewController.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavViewController.h"
#import "CentralViewController.h"
#import "MediaPlayerViewController.h"
#import "LoadingViewController.h"

@interface InitialViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *mediaPlayerHolder;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UIView *loadingIndicatorHolder;
@property (nonatomic, strong) LoadingViewController *loadingIndicatorViewController;

@end
