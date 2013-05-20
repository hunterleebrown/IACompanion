//
//  HomeCollectionViewController.m
//  IA
//
//  Created by Hunter on 2/18/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveCollectionListViewController.h"
#import "HomeContentCell.h"
#import "ArchiveSearchDoc.h"
#import "ArchiveDetailedViewController.h"
#import "ArchiveDataService.h"

@interface ArchiveCollectionListViewController ()

@end

@implementation ArchiveCollectionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.contentParentView.homeContentTableView.service getDocsWithCollectionIdentifier:_identifier];
    [self.contentParentView hideSplashView];
    [self.collectionTitleLabel setText:_collectionTitle];
    [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:0]];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"collectionCellPush"]){
        
        HomeContentCell *cell = (HomeContentCell *)sender;
        ArchiveSearchDoc *doc = cell.doc;
        
        ArchiveDetailedViewController *detailViewController = [segue destinationViewController];
        [detailViewController setTitle:doc.title];
        [detailViewController setIdentifier:doc.identifier];
    }
}


- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setIdentifier:(NSString *)identifier{
    _identifier = identifier;
}


- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    int index = [tabBar.items indexOfObject:tabBar.selectedItem];
    
    
    switch (index) {
        case 0:
            [_contentParentView.homeContentTableView.service getDocsWithCollectionIdentifier:_identifier];
            break;
        case 1:
            [_contentParentView.homeContentTableView.service getDocsWithType:MediaTypeNone withIdentifier:_identifier withSort:@"downloads+desc"];
            break;
        case 2:
            [_contentParentView.homeContentTableView.service getStaffPicksDocsWithCollectionIdentifier:_identifier];
            break;
        default:
            break;
    }
    
}


- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toggleContent:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];
}

- (IBAction)popToRoot:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
