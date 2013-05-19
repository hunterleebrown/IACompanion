//
//  HomeCollectionViewController.h
//  IA
//
//  Created by Hunter on 2/18/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContentParentView.h"

@interface ArchiveCollectionListViewController : UIViewController

@property (nonatomic, weak) IBOutlet HomeContentParentView *contentParentView;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UILabel *collectionTitleLabel;
@property (nonatomic, strong) NSString *collectionTitle;

- (IBAction)popBack:(id)sender;

- (IBAction)toggleContent:(id)sender;
- (IBAction)popToRoot:(id)sender;


@end
