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

@interface InitialViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *mediaPlayerHolder;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
