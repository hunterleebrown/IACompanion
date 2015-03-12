//
//  SearchViewController.m
//  IA
//
//  Created by Hunter on 7/23/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "SearchViewController.h"
#import "IAJsonDataService.h"
#import "ArchiveSearchDoc.h"
#import "CollectionViewTableCell.h"
#import "StringUtils.h"
#import "MediaUtils.h"
#import "FontMapping.h"
#import "ItemContentViewController.h"
#import "SorterView.h"
#import "SearchCollectionViewCell.h"
#import "LayoutChangerView.h"
#import "ArchiveContentTypeControlView.h"

@interface SearchViewController () <IADataServiceDelegate>
@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) NSInteger numFound;
@property (assign) NSInteger start;
@property (assign) BOOL didTriggerLoadMore;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UILabel *numFoundLabel;


@property (nonatomic, weak) IBOutlet SorterView *sorterView;


@property (nonatomic, weak) IBOutlet UICollectionView *searchCollectionView;
@property (nonatomic) CellLayoutStyle *cellLayoutStyle;
@property (nonatomic, weak) IBOutlet LayoutChangerView *layoutChangerView;

@property (nonatomic, weak) IBOutlet ArchiveContentTypeControlView *contentTypeControlView;

@end

@implementation SearchViewController
@synthesize service, searchBar, searchDocuments, numFound, start, didTriggerLoadMore;


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
    
    searchDocuments = [NSMutableArray new];
    didTriggerLoadMore = NO;

    [self.closeButton setTitle:CLOSE forState:UIControlStateNormal];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setTranslucent:NO];

    self.contentTypeControlView.selectButtonBlock = ^(NSString *param){
        [self searchFilterChangeWithParam:param];
    };
}
- (void) viewDidAppear:(BOOL)animated {
    for(id subview in [searchBar subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }

}

- (void) viewDidDisappear:(BOOL)animated{
    [searchBar resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];

}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}




#pragma mark - top buttons
- (void) didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];
}



- (void) didPressMPButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}













#pragma mark -

- (IBAction)didPressCloseButton:(id)sender
{
    [self closeSearch];
}
- (void)closeSearch
{
    [self.searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewControllerClose" object:nil];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)inSearchBar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewControllerClose" object:nil];
    [inSearchBar resignFirstResponder];    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)inSearchBar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
    [self.sorterView resetSortButtons];

    if(self.contentTypeControlView.currentMediaType != MediaTypeNone)
    {
        service = [[IAJsonDataService alloc] initWithQueryString:[NSString stringWithFormat:@"%@%@", searchBar.text, [self.contentTypeControlView filterQueryParam:self.contentTypeControlView.currentMediaType]]];
        [self.sorterView setService:service];
    }
    else{
        service = [[IAJsonDataService alloc] initWithQueryString:searchBar.text];
        [self.sorterView setService:service];
    }

    [service setDelegate:self];
    [service fetchData];
    [inSearchBar resignFirstResponder];

}





- (void) searchFilterChangeWithParam:(NSString *)param
{
    if(![searchBar.text isEqualToString:@""]){
        [self.sorterView resetSortButtons];

        service = [[IAJsonDataService alloc] initWithQueryString:[NSString stringWithFormat:@"%@%@", searchBar.text, param]];
        [self.sorterView setService:service];

        [service setDelegate:self];
        [service fetchData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
        [searchBar resignFirstResponder];
    }

}



- (void) dataDidBecomeAvailableForService:(IADataService *)serv {
   
    [self.sorterView serviceDidReturn];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];
    
    if(service.rawResults && [service.rawResults objectForKey:@"documents"]){
        
        if(!didTriggerLoadMore) {
            [searchDocuments removeAllObjects];
        }
        [searchDocuments addObjectsFromArray:[service.rawResults objectForKey:@"documents"]];
        numFound  = [[service.rawResults objectForKey:@"numFound"] intValue];
        
        [self.searchCollectionView reloadData];
        [_numFoundLabel setText:[NSString stringWithFormat:@"%@ items found", [StringUtils decimalFormatNumberFromInteger:numFound]]];
        
        if(!didTriggerLoadMore) {
            [self.searchCollectionView setContentOffset:CGPointZero animated:YES];
        }
    }
    didTriggerLoadMore = NO;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchBar resignFirstResponder];
    if(scrollView.contentOffset.y > scrollView.contentSize.height * 0.5)
    {
        if(searchDocuments.count > 0  && searchDocuments.count < numFound  && start < numFound && !didTriggerLoadMore){
            [self loadMoreItems:nil];
        }
    }
}

- (void)loadMoreItems:(id)sender {
    if(numFound > 50) {
        didTriggerLoadMore = YES;
        start = start + 50;
        
        [service setLoadMoreStart:[NSString stringWithFormat:@"%li", (long)start]];
        [service fetchData];
        
    }
}






#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [searchDocuments count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];

    [cell setArchiveSearchDoc:doc];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    ItemContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
    [cvc setSearchDoc:doc];
    [self.navigationController pushViewController:cvc animated:YES];


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    return [SearchCollectionViewCell sizeForOrientation:self.interfaceOrientation collectionView:collectionView cellLayoutStyle:self.layoutChangerView.cellLayoutStyle archiveDoc:doc];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.searchCollectionView.collectionViewLayout invalidateLayout];
}




@end
