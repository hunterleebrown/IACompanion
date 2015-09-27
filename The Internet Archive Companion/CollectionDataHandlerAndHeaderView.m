//
//  CollectionDataHandler.m
//  IA
//
//  Created by Hunter on 7/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CollectionDataHandlerAndHeaderView.h"
#import "IAJsonDataService.h"
#import "ArchiveSearchDoc.h"
#import "CollectionViewTableCell.h"
#import "StringUtils.h"
#import "SorterView.h"
#import "SearchCollectionViewCell.h"
#import "ItemContentViewController.h"

@interface CollectionDataHandlerAndHeaderView ()

@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) NSInteger numFound;
@property (assign) NSInteger start;
@property (assign) BOOL didTriggerLoadMore;

@property (nonatomic, weak) IBOutlet SorterView *sorterView;

@property (nonatomic) BOOL controlsFadedOut;


@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation CollectionDataHandlerAndHeaderView
@synthesize service, identifier, searchDocuments, collectionTableView, numFound, didTriggerLoadMore, start;



- (void)handleRefresh
{
//    [self.refreshControl beginRefreshing];
    [service fetchData];
    
}

- (void) setIdentifier:(NSString *)ident {
    

    searchDocuments = [NSMutableArray new];
    numFound = 0;
    start = 0;
    didTriggerLoadMore = NO;
    identifier = ident;
    service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeNone];
        [self.sorterView setService:service];
    [service setDelegate:self];
    [service fetchData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];


    [self.collectionView setScrollsToTop:YES];
    
    if (!self.refreshControl) {
        self.refreshControl = [UIRefreshControl new];
        [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
        [self.collectionView setAlwaysBounceVertical:YES];
        [self.refreshControl setTintColor:[UIColor whiteColor]];
        [self.collectionView addSubview:self.refreshControl];
    }
}

- (void) dataDidBecomeAvailableForService:(IADataService *)serv{
    [self.sorterView serviceDidReturn];
    [self.refreshControl endRefreshing];

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];

    if(service.rawResults && [service.rawResults objectForKey:@"documents"]){
        
        if(!didTriggerLoadMore) {
            [searchDocuments removeAllObjects];
        }
        [searchDocuments addObjectsFromArray:[service.rawResults objectForKey:@"documents"]];
        numFound  = [[service.rawResults objectForKey:@"numFound"] intValue];

//        [collectionTableView reloadData];
        [self.collectionView reloadData];
        
        [_countLabel setText:[NSString stringWithFormat:@"%@ items found", [StringUtils decimalFormatNumberFromInteger:numFound]]];
        
        if(!didTriggerLoadMore) {
            [collectionTableView setContentOffset:CGPointZero animated:YES];
            [self.collectionView setContentOffset:CGPointZero animated:YES];

        }
    }
    didTriggerLoadMore = NO;

    

}

#pragma mark - Table View


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    [cell load:doc];
    
    return cell;
}




#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [searchDocuments count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemSearchCollectionCell" forIndexPath:indexPath];
    
    [cell setArchiveSearchDoc:doc];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || doc.type == MediaTypeCollection) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
//    }
//    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        ItemContentViewController *cvc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
//        [cvc setSearchDoc:doc];
//        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:cvc];
//        SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemSearchCollectionCell" forIndexPath:indexPath];
//        [pop presentPopoverFromRect:cell.frame inView:collectionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        
//    }
    
    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ItemContentViewController *cvc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
    [cvc setSearchDoc:doc];

    [cell handleTapWithDesitnationViewController:cvc presentingController:self.parentViewController collectionView:collectionView];

    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    return [SearchCollectionViewCell sizeForOrientation:[[UIApplication sharedApplication]statusBarOrientation] collectionView:collectionView cellLayoutStyle:self.layoutChangerView.cellLayoutStyle archiveDoc:doc];
}


#pragma mark -

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 375){
    if(scrollView.contentOffset.y > scrollView.contentSize.height * 0.5) {

        if(searchDocuments.count > 0  && searchDocuments.count < numFound  && start < numFound && !didTriggerLoadMore){
            [self loadMoreItems:nil];
        }
    }
    
    
    if(scrollView == self.collectionView)
    {
        if( [scrollView.panGestureRecognizer translationInView:scrollView.superview].y < 0 )
        {
            [self fadeOutToolbar:YES];
        }
        else
        {
            [self fadeOutToolbar:NO];
        }
        
    }
    
}


- (void)forceFadeOutToolbar:(BOOL)fadeOut
{
    [UIView animateWithDuration:0.33 animations:^{
        
        self.layoutChangerView.alpha = fadeOut ? 0.0 : 1.0;
        self.sorterView.alpha = fadeOut ? 0.0 : 1.0;
        
    } completion:^(BOOL finished) {
        self.controlsFadedOut = fadeOut;
    }];
}

- (void)fadeOutToolbar:(BOOL)fadeOut
{
    if(self.controlsFadedOut != fadeOut)
    {
        [self forceFadeOutToolbar:fadeOut];
    }
}




- (IBAction)searchCollection:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewController" object:identifier];
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    UISegmentedControl *seggers = (UISegmentedControl *)sender;
    switch (seggers.selectedSegmentIndex) {
//        case 0:
//            service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeDownloadDescending];
//            [self.sorterView setService:service];
//            [service setDelegate:self];
//            [service fetchData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
//
//            break;
//        case 1:
//            service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeDateDescending];
//            [self.sorterView setService:service];
//            [service setDelegate:self];
//            [service fetchData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
//            
//            break;
        case 0:
            service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeNone];
            service.delegate = self;
            [self.sorterView setService:service];
            [service fetchData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

            break;

        case 1:
            [service changeToStaffPicks];
            [service fetchData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

            break;

        default:
            break;
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



@end
