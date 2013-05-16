//
//  ArchiveFavoritesViewController.h
//  IA
//
//  Created by Hunter Brown on 5/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveFavoritesViewController : UIViewController


@property (nonatomic, weak) IBOutlet UIButton *toggleFavoritesButton;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)toggle:(id)sender;
@end
