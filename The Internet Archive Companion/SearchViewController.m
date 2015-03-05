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

@interface SearchViewController () <IADataServiceDelegate>
@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) NSMutableArray *searchDocuments;
@property (assign) NSInteger numFound;
@property (assign) NSInteger start;
@property (assign) BOOL didTriggerLoadMore;
@property (nonatomic, weak) UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UILabel *numFoundLabel;


@property (nonatomic, weak) IBOutlet SorterView *sorterView;

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
    
    [self.navigationItem setLeftBarButtonItems:nil];
   
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:CLOSE style:UIBarButtonSystemItemCancel target:self action:@selector(closeSearch)];
    [closeItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItems:@[closeItem]];
    
    
    
    [self.searchFilters setTitleTextAttributes:@{NSFontAttributeName : ICONOCHIVE_FONT, NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    
    [self.searchFilters setTitle:ARCHIVE forSegmentAtIndex:0];    
    [self.searchFilters setTitle:AUDIO forSegmentAtIndex:1];
    [self.searchFilters setTitle:VIDEO forSegmentAtIndex:2];
    [self.searchFilters setTitle:BOOK  forSegmentAtIndex:3];
    [self.searchFilters setTitle:IMAGE forSegmentAtIndex:4];
    

    self.searchFilters.layer.borderColor = [UIColor clearColor].CGColor;


 

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

#pragma mark - top buttons
- (void) didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];
}



- (void) didPressMPButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}


- (void) didPressBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}










#pragma mark -


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

    if([self filterQueryParam])
    {
        service = [[IAJsonDataService alloc] initWithQueryString:[NSString stringWithFormat:@"%@%@", searchBar.text, [self filterQueryParam]]];
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


- (NSString *)filterQueryParam
{

    NSInteger selectedSegment = searchFilters.selectedSegmentIndex;
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

    return extraSearchParam;

}


- (IBAction)searchFilterChange:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segment.selectedSegmentIndex;
    // audio, video, text, image

    NSString *extraSearchParam = [self filterQueryParam];


    if(![searchBar.text isEqualToString:@""]){
        [self.sorterView resetSortButtons];
        
        service = [[IAJsonDataService alloc] initWithQueryString:[NSString stringWithFormat:@"%@%@", searchBar.text, extraSearchParam]];
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



#pragma mark - TableView

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
    

        ItemContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
        [cvc setSearchDoc:doc];
    
//        [self pushViewController:cvc animated:YES];
    [self.navigationController pushViewController:cvc animated:YES];
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDocuments count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
    ArchiveSearchDoc *doc = [searchDocuments objectAtIndex:indexPath.row];
    [cell load:doc];

    return cell;
    
}

@end
