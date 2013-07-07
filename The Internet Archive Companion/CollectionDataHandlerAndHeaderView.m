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

@interface CollectionDataHandlerAndHeaderView ()

@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) int numFound;
@property (assign) int start;
@property (assign) BOOL didTriggerLoadMore;

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
    searchDocuments = [NSMutableArray new];
    numFound = 0;
    start = 0;
    didTriggerLoadMore = NO;
    identifier = ident;
    service = [[IAJsonDataService alloc] initForAllItemsWithCollectionIdentifier:identifier sortType:IADataServiceSortTypeDateDescending];
    [service setDelegate:self];
    [service fetchData];
    

    
    
}

- (void) dataDidBecomeAvailableForService:(IADataService *)serv{

    if(service.rawResults && [service.rawResults objectForKey:@"documents"]){
        
        if(!didTriggerLoadMore) {
            [searchDocuments removeAllObjects];
        }
        [searchDocuments addObjectsFromArray:[service.rawResults objectForKey:@"documents"]];
        numFound  = [[service.rawResults objectForKey:@"numFound"] intValue];

        [collectionTableView reloadData];
    }
    didTriggerLoadMore = NO;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    cell.title.text = doc.title;
    cell.archiveImageView.archiveImage = doc.archiveImage;
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = [scrollView contentOffset];
    if(contentOffset.y >= 215){
        [self setFrame:CGRectMake(0, contentOffset.y, self.frame.size.width, self.frame.size.height)];
    } else {
        [self setFrame:CGRectMake(0,214, self.frame.size.width, self.frame.size.height)];

    }
    
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 300){
        if(searchDocuments.count > 0  && searchDocuments.count < numFound  && start < numFound && !didTriggerLoadMore){
            [self loadMoreItems:nil];

        }
        
    }
    
}

- (void)loadMoreItems:(id)sender {
    didTriggerLoadMore = YES;
    start = start + 50;
    // NSLog(@"-----> trigger loadmore");
    // NSLog(@" docs.count:%i  numFound:%i   start:%i", docs.count, numFound, start);
    
    [service setLoadMoreStart:[NSString stringWithFormat:@"%i", start]];
    [service fetchData];
}

@end
