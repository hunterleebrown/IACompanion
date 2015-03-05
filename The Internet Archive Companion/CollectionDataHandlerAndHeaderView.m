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

@interface CollectionDataHandlerAndHeaderView ()

@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) NSInteger numFound;
@property (assign) NSInteger start;
@property (assign) BOOL didTriggerLoadMore;

@property (nonatomic, weak) IBOutlet SorterView *sorterView;

@end

@implementation CollectionDataHandlerAndHeaderView
@synthesize service, identifier, searchDocuments, collectionTableView, numFound, didTriggerLoadMore, start;

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        

    
        
    }
    return self;
}


- (void) setIdentifier:(NSString *)ident {
    
    
    [collectionTableView setScrollsToTop:YES];
    
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


    [collectionTableView setScrollsToTop:YES];
}

- (void) dataDidBecomeAvailableForService:(IADataService *)serv{
    [self.sorterView serviceDidReturn];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];

    if(service.rawResults && [service.rawResults objectForKey:@"documents"]){
        
        if(!didTriggerLoadMore) {
            [searchDocuments removeAllObjects];
        }
        [searchDocuments addObjectsFromArray:[service.rawResults objectForKey:@"documents"]];
        numFound  = [[service.rawResults objectForKey:@"numFound"] intValue];

        [collectionTableView reloadData];
        [_countLabel setText:[NSString stringWithFormat:@"%@ items found", [StringUtils decimalFormatNumberFromInteger:numFound]]];
        
        if(!didTriggerLoadMore) {
            [collectionTableView setContentOffset:CGPointZero animated:YES];
        }
    }
    didTriggerLoadMore = NO;

    

}

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

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 375){
        if(searchDocuments.count > 0  && searchDocuments.count < numFound  && start < numFound && !didTriggerLoadMore){
            [self loadMoreItems:nil];

        }
        
    }
    
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
            [service changeToSubCollections];
            [service fetchData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

            break;

        case 1:
            [service changeToStaffPicks];
            [service fetchData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewController" object:identifier];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

    }
}

@end
