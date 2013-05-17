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
#import "ArchiveFavoritesViewController.h"

@interface HomeViewController : UIViewController

@property (nonatomic, retain) UINavigationController *contentController;
@property (nonatomic, retain) IBOutlet ArchivePlayerViewController *playerController;
@property (nonatomic, retain) IBOutlet ArchiveFavoritesViewController *favoritesController;

@property (nonatomic, weak) IBOutlet UIView *top;
@property (nonatomic, weak) IBOutlet UIView *bottom;
@property (nonatomic, weak) IBOutlet UIView *favorites;
@property (nonatomic, weak) IBOutlet UIImageView *shadow;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, weak) IBOutlet UILabel *animatedLabel;

- (void)hidePlayer;
- (IBAction)togglerPlayer:(id)sender;

@end
