//
//  HomeCollectionViewController.h
//  IA
//
//  Created by Hunter on 2/18/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContentParentView.h"

@interface ArchiveCollectionListViewController : UIViewController<UITabBarDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet HomeContentParentView *contentParentView;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UILabel *collectionTitleLabel;
@property (nonatomic, strong) NSString *collectionTitle;

@property (nonatomic, weak) IBOutlet UITabBar *tabBar;

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;


- (IBAction)popBack:(id)sender;

- (IBAction)toggleContent:(id)sender;
- (IBAction)popToRoot:(id)sender;


@end
