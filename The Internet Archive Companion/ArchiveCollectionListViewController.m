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
#import "ArchiveCollectionDetailedViewController.h"

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
            [self hideSearch];
            [_contentParentView.homeContentTableView.service getDocsWithCollectionIdentifier:_identifier];
            break;
        case 1:
            [self hideSearch];
            [_contentParentView.homeContentTableView.service getDocsWithType:MediaTypeNone withIdentifier:_identifier withSort:@"downloads+desc"];
            break;
        case 2:
            [self hideSearch];
            [_contentParentView.homeContentTableView.service getStaffPicksDocsWithCollectionIdentifier:_identifier];
            break;
        case 3:
            [self toggleSearch:nil];
            break;
        default:
            break;
    }
    
}


- (void) hideSearch{
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [_searchView setFrame:CGRectMake(0, -20, _searchView.bounds.size.width, _searchView.bounds.size.height)];
    }];
}

- (void) showSearch{
    [UIView animateWithDuration:0.3 animations:^{
        [_searchView setFrame:CGRectMake(0, 52, _searchView.bounds.size.width, _searchView.bounds.size.height)];
        [_searchBar becomeFirstResponder];
    }];
}

- (IBAction)toggleSearch:(id)sender {
    
    
    if(_searchView.frame.origin.y != 52){
        [self showSearch];
    } else {
        [self hideSearch];
    }

}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self toggleSearch:nil];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@" search: %@", searchBar.text);
    [searchBar resignFirstResponder];
    [self toggleSearch:nil];
    [_contentParentView.homeContentTableView.service getDocsWithQueryString:[NSString stringWithFormat:@"%@ collection:%@", searchBar.text,_identifier]];

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
