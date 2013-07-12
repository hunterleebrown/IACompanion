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
#import "ArchiveLoadingView.h"

@interface CollectionDataHandlerAndHeaderView ()

@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) int numFound;
@property (assign) int start;
@property (assign) BOOL didTriggerLoadMore;
@property (nonatomic, weak) IBOutlet ArchiveLoadingView *loadingIndicator;

@end

@implementation CollectionDataHandlerAndHeaderView
@synthesize service, identifier, searchDocuments, collectionTableView, numFound, didTriggerLoadMore, start, loadingIndicator;

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
    service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeDateDescending];
    [service setDelegate:self];
    [service fetchData];

    [collectionTableView setScrollsToTop:YES];
    [loadingIndicator startAnimating];
}

- (void) dataDidBecomeAvailableForService:(IADataService *)serv{

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
    [loadingIndicator stopAnimating];

    

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];

}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    cell.title.text = doc.title;
    cell.archiveImageView.archiveImage = doc.archiveImage;
    
    if(doc.type == MediaTypeCollection){
        [cell.collectionBanner setHidden:NO];
    } else {
        
        [cell.collectionBanner setHidden:YES];
    }
    
    
    return cell;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*
    CGPoint contentOffset = [scrollView contentOffset];
    if(contentOffset.y > 200){
        [self setFrame:CGRectMake(0, contentOffset.y, self.frame.size.width, self.frame.size.height)];
    } else {
        [self setFrame:CGRectMake(0, 200, self.frame.size.width, self.frame.size.height)];

    }
    */
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 300){
        if(searchDocuments.count > 0  && searchDocuments.count < numFound  && start < numFound && !didTriggerLoadMore){
            [self loadMoreItems:nil];

        }
        
    }
    
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    UISegmentedControl *seggers = (UISegmentedControl *)sender;
    switch (seggers.selectedSegmentIndex) {
        case 0:
            service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeDateDescending];
            [service setDelegate:self];
            [service fetchData];
            break;
        case 1:
            [service changeToSubCollections];
            [service fetchData];
            break;
        case 2:
            service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeDownloadCount];
            [service setDelegate:self];
            [service fetchData];
            break;
        case 3:
            [service changeToStaffPicks];
            [service fetchData];
            break;
            
        default:
            break;
    }
    [loadingIndicator startAnimating];

}



- (void)loadMoreItems:(id)sender {
    if(numFound > 50) {
        didTriggerLoadMore = YES;
        start = start + 50;
        // NSLog(@"-----> trigger loadmore");
        // NSLog(@" docs.count:%i  numFound:%i   start:%i", docs.count, numFound, start);
        
        [loadingIndicator startAnimating];
        [service setLoadMoreStart:[NSString stringWithFormat:@"%i", start]];
        [service fetchData];
    }
}

@end
