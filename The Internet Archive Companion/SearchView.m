//
//  SearchView.m
//  IA
//
//  Created by Hunter Brown on 7/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "SearchView.h"
#import "IAJsonDataService.h"
#import "CollectionViewTableCell.h"
#import "ArchiveSearchDoc.h"

@interface SearchView () <IADataServiceDelegate>

@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) int numFound;
@property (assign) int start;
@property (assign) BOOL didTriggerLoadMore;
@end

@implementation SearchView
@synthesize service, searchResultsTable, searchBar, searchFilters, searchDocuments, numFound, start, didTriggerLoadMore;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        searchDocuments = [NSMutableArray new];
        didTriggerLoadMore = NO;
    }
    return self;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    service = [[IAJsonDataService alloc] initWithQueryString:searchBar.text];
    [service setDelegate:self];
    [service fetchData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
}

- (IBAction)searchFilterChange:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    int selectedSegment = segment.selectedSegmentIndex;
    // audio, video, text, image
    
    NSString *extraSearchParam = @"";
    
    switch (selectedSegment) {
        case 0:

            break;
        case 1:
            extraSearchParam = @"+AND+mediatype:audio";
            break;
        case 2:
            extraSearchParam = @"+AND+mediatype:movies";
            break;
        case 3:
            extraSearchParam = @"+AND+mediatype:texts";            
            break;
        case 4:
            extraSearchParam = @"+AND+mediatype:image";            
            break;
        default:
            break;
    }
 
    
    if(![searchBar.text isEqualToString:@""]){
        service = [[IAJsonDataService alloc] initWithQueryString:[NSString stringWithFormat:@"%@%@", searchBar.text, extraSearchParam]];
        [service setDelegate:self];
        [service fetchData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
    }
    
}


- (void) dataDidBecomeAvailableForService:(IADataService *)serv {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];
    
    if(service.rawResults && [service.rawResults objectForKey:@"documents"]){
        
        if(!didTriggerLoadMore) {
            [searchDocuments removeAllObjects];
        }
        [searchDocuments addObjectsFromArray:[service.rawResults objectForKey:@"documents"]];
        numFound  = [[service.rawResults objectForKey:@"numFound"] intValue];
        
        [searchResultsTable reloadData];
       // [_countLabel setText:[NSString stringWithFormat:@"%@ items found", [StringUtils decimalFormatNumberFromInteger:numFound]]];
        
        if(!didTriggerLoadMore) {
            [searchResultsTable setContentOffset:CGPointZero animated:YES];
        }
    }
    didTriggerLoadMore = NO;
    [searchResultsTable setHidden:NO];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchBar resignFirstResponder];
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 375){
        if(searchDocuments.count > 0  && searchDocuments.count < numFound  && start < numFound && !didTriggerLoadMore){
            [self loadMoreItems:nil];
        }
    }
    
    
}

- (void)loadMoreItems:(id)sender {
    if(numFound > 50) {
        didTriggerLoadMore = YES;
        start = start + 50;
        
        [service setLoadMoreStart:[NSString stringWithFormat:@"%i", start]];
        [service fetchData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
        
    }
}




- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
    
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
    
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
