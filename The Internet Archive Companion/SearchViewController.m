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

@interface SearchViewController () <IADataServiceDelegate>
@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) NSInteger numFound;
@property (assign) NSInteger start;
@property (assign) BOOL didTriggerLoadMore;

@property (nonatomic, weak) IBOutlet UILabel *numFoundLabel;

@end

@implementation SearchViewController
@synthesize service, searchResultsTable, searchBar, searchFilters, searchDocuments, numFound, start, didTriggerLoadMore;


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
    
    
    
    UIImage *image = [UIImage imageNamed:@"new-list.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 10, image.size.height);
    button.tag = 0;
    [button addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
 
    
    
    UIImage *bi = [UIImage imageNamed:@"back-button.png"];
    UIButton *bibutton = [UIButton buttonWithType:UIButtonTypeCustom];
    bibutton.frame = CGRectMake(0, 0, bi.size.width, bi.size.height);
    bibutton.tag = 0;
    [bibutton addTarget:self action:@selector(didPressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [bibutton setImage:bi forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:bibutton];
    
    
    
    
    UIImage *mpi = [UIImage imageNamed:@"open-player-button.png"];
    UIButton *mpbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    mpbutton.frame = CGRectMake(0, 0, mpi.size.width, mpi.size.height);
    mpbutton.tag = 1;
    [mpbutton addTarget:self action:@selector(didPressMPButton) forControlEvents:UIControlEventTouchUpInside];
    [mpbutton setImage:mpi forState:UIControlStateNormal];
    UIBarButtonItem* mpBarButton = [[UIBarButtonItem alloc] initWithCustomView:mpbutton];
    
    [self.navigationItem setLeftBarButtonItems:@[listButton, mpBarButton, backButton]];
    


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
    [searchResultsTable deselectRowAtIndexPath:searchResultsTable.indexPathForSelectedRow animated:YES];

}


- (void) didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];
}


- (void) didPressMPButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}


- (void) didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) searchBarCancelButtonClicked:(UISearchBar *)inSearchBar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewControllerClose" object:nil];
    [inSearchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)inSearchBar{
    service = [[IAJsonDataService alloc] initWithQueryString:searchBar.text];
    [service setDelegate:self];
    [service fetchData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
    [inSearchBar resignFirstResponder];

}

- (IBAction)searchFilterChange:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segment.selectedSegmentIndex;
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
        [searchBar resignFirstResponder];
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
        [_numFoundLabel setText:[NSString stringWithFormat:@"%@ items found", [StringUtils decimalFormatNumberFromInteger:numFound]]];
        
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
        
        [service setLoadMoreStart:[NSString stringWithFormat:@"%li", (long)start]];
        [service fetchData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
        
    }
}




- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
    
    
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    cell.title.text = doc.title;
    cell.archiveImageView.archiveImage = doc.archiveImage;
    cell.decription.text = [StringUtils stringByStrippingHTML:doc.details];
    
    if(doc.type == MediaTypeCollection){
        [cell.collectionBanner setHidden:NO];
    } else {
        
        [cell.collectionBanner setHidden:YES];
    }
    
    
    return cell;
    
}

@end
