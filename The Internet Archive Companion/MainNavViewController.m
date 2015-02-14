//
//  HomeViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MainNavViewController.h"
#import "MainNavTableViewCell.h"
#import "MainNavTableViewHeaderViewCell.h"
#import "ArchiveSearchDoc.h"
#import "IAJsonDataService.h"



@interface MainNavViewController () <UITableViewDataSource, UITableViewDelegate, IADataServiceDelegate>

@property (nonatomic, weak) IBOutlet UITableView *navTable;
@property (nonatomic, strong) NSMutableArray *audioSearchDocuments;
@property (nonatomic, strong) NSMutableArray *videoSearchDocuments;
@property (nonatomic, strong) NSMutableArray *textSearchDocuments;

@property (nonatomic, strong) IAJsonDataService *audioService;
@property (nonatomic, strong) IAJsonDataService *videoService;
@property (nonatomic, strong) IAJsonDataService *textService;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end


@implementation MainNavViewController

@synthesize navTable;
@synthesize audioSearchDocuments, videoSearchDocuments, textSearchDocuments, refreshControl;
@synthesize audioService, videoService, textService;

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        audioSearchDocuments = [NSMutableArray new];
        videoSearchDocuments = [NSMutableArray new];
        textSearchDocuments = [NSMutableArray new];
        
        audioService = [[IAJsonDataService alloc] initForAllCollectionItemsWithCollectionIdentifier:@"audio" sortType:IADataServiceTitleAscending];
        videoService = [[IAJsonDataService alloc] initForAllCollectionItemsWithCollectionIdentifier:@"movies AND NOT COLLECTION:tvarchive" sortType:IADataServiceTitleAscending];
        textService = [[IAJsonDataService alloc] initForAllCollectionItemsWithCollectionIdentifier:@"texts" sortType:IADataServiceTitleAscending];

        [audioService setDelegate:self];
        [videoService setDelegate:self];
        [textService setDelegate:self];
        
        

        
    }
    return self;
}

- (void) handleRefresh {
    
    [audioService fetchData];
    [videoService fetchData];
    [textService fetchData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor blackColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefreshing) name:@"EndRefreshing" object:nil];

    
    [audioService fetchData];
    [videoService fetchData];
    [textService fetchData];
    [navTable setScrollsToTop:NO];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [navTable addSubview:refreshControl];
}

- (void) endRefreshing
{
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dataDidBecomeAvailableForService:(IADataService *)serv{
    [refreshControl endRefreshing];

    
    if(serv == audioService && audioService.rawResults && [audioService.rawResults objectForKey:@"documents"]){
        [audioSearchDocuments removeAllObjects];
        
        ArchiveSearchDoc *allAudio = [ArchiveSearchDoc new];
        [allAudio setType:MediaTypeCollection];
        [allAudio setIdentifier:@"audio"];
        [allAudio setTitle:@"ALL AUDIO"];
        
        ArchiveImage *audImage = [[ArchiveImage alloc] initWithUrlPath:[NSString stringWithFormat:@"http://archive.org/services/img/%@", @"audio"]];
        [allAudio setArchiveImage:audImage];
        
        
        [audioSearchDocuments addObject:allAudio];
    
        [audioSearchDocuments addObjectsFromArray:[audioService.rawResults objectForKey:@"documents"]];
    }
    if(serv == videoService && videoService.rawResults && [videoService.rawResults objectForKey:@"documents"]){
        [videoSearchDocuments removeAllObjects];
        
        ArchiveSearchDoc *topVideo = [ArchiveSearchDoc new];
        [topVideo setIdentifier:@"movies"];
        [topVideo setType:MediaTypeCollection];
        [topVideo setTitle:@"ALL VIDEO"];
        ArchiveImage *vidImg = [[ArchiveImage alloc] initWithUrlPath:[NSString stringWithFormat:@"http://archive.org/services/img/%@", @"movies"]];
        [topVideo setArchiveImage:vidImg];
        [videoSearchDocuments addObject:topVideo];
        
        [videoSearchDocuments addObjectsFromArray:[videoService.rawResults objectForKey:@"documents"]];
    }
    if(serv == textService && textService.rawResults && [textService.rawResults objectForKey:@"documents"]){
        [textSearchDocuments removeAllObjects];
        
        ArchiveSearchDoc *topTexts = [ArchiveSearchDoc new];
        [topTexts setIdentifier:@"texts"];
        [topTexts setType:MediaTypeCollection];
        [topTexts setTitle:@"ALL TEXTS"];
        ArchiveImage *textImg = [[ArchiveImage alloc] initWithUrlPath:[NSString stringWithFormat:@"http://archive.org/services/img/%@", @"texts"]];
        [topTexts setArchiveImage:textImg];
        [textSearchDocuments addObject:topTexts];
        
        [textSearchDocuments addObjectsFromArray:[textService.rawResults objectForKey:@"documents"]];
    }
    [navTable reloadData];
    
    
}




#pragma mark - table
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return [audioSearchDocuments count];
            break;
        case 2:
            return [videoSearchDocuments count];
            break;
        case 3:
            return [textSearchDocuments count];
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainNavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainNavCell"];
    [cell.navImageView setArchiveImage:nil];

    [cell.navImageView setHidden:YES];
    [cell.navImageView setBackgroundColor:[UIColor whiteColor]];
    
    ArchiveSearchDoc *doc;
    switch (indexPath.section) {
        case 0:
            
            if(indexPath.row == 0) {
                [cell.navCellTitleLabel setText:@"Home"];
                [cell.navImageView setImage:[UIImage imageNamed:@"ia-button-plain.png"]];
                [cell.navImageView setBackgroundColor:[UIColor blackColor]];
                [cell setBackgroundColor:[UIColor blackColor]];
            } else if(indexPath.row == 1) {
                [cell.navCellTitleLabel setText:@"Media Player"];
                [cell.navImageView setImage:[UIImage imageNamed:@"open-player-button.png"]];
                [cell.navImageView setBackgroundColor:[UIColor blackColor]];
                [cell setBackgroundColor:[UIColor blackColor]];
            }
            else if(indexPath.row == 2) {
                [cell.navCellTitleLabel setText:@"Favorites"];
                [cell.navImageView setImage:[UIImage imageNamed:@"favorites_button.png"]];
                [cell.navImageView setBackgroundColor:[UIColor blackColor]];
                [cell setBackgroundColor:[UIColor blackColor]];
            }
            
            [cell.navImageView setHidden:NO];
            return cell;
            
            
            break;
        case 1:
            doc = [audioSearchDocuments objectAtIndex:indexPath.row];
            break;
        case 2:
            doc = [videoSearchDocuments objectAtIndex:indexPath.row];
            break;
        case 3:
            doc = [textSearchDocuments objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    [cell.navCellTitleLabel setHidden:NO];
    [cell.navImageView setHidden:NO];
    [cell.navCellTitleLabel setText:doc.title];
    [cell.navImageView setArchiveImage:doc.archiveImage];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"Audio Collections";
            break;
        case 2:
            return @"Video Collections";
            break;
        case 3:
            return @"Text Collections";
            break;
        default:
            return 0;
            break;
    }
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;            
        default:
            return 22;
            break;
    }

}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MainNavTableViewHeaderViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"mainNavSectionHeader"];
    switch (section) {
        case 0:
            return nil;
        case 1:
            headerCell.sectionLabel.text =  @"Audio Collections";
            break;
        case 2:
            headerCell.sectionLabel.text =  @"Video Collections";
            break;
        case 3:
            headerCell.sectionLabel.text =  @"Text Collections";
            break;
        default:
            headerCell.sectionLabel.text =  @"";
            break;
    }
    return headerCell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArchiveSearchDoc *doc;
    switch (indexPath.section) {
        case 0:
            
            if(indexPath.row == 0){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopToHome" object:nil];
                return;
            } else if(indexPath.row == 1){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
                return;
            } else if(indexPath.row == 2){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFavorites" object:nil];
                return;
            }
            
            
            break;
        case 1:
            doc = [audioSearchDocuments objectAtIndex:indexPath.row];
            break;
        case 2:
            doc = [videoSearchDocuments objectAtIndex:indexPath.row];
            break;
        case 3:
            doc = [textSearchDocuments objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavCellNotification" object:doc];
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    return NO;
}




@end
