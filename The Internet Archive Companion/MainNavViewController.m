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
#import "FontMapping.h"



@interface MainNavViewController () <UITableViewDataSource, UITableViewDelegate, IADataServiceDelegate>

@property (nonatomic, weak) IBOutlet UITableView *navTable;
@property (nonatomic, strong) NSMutableArray *audioSearchDocuments;
@property (nonatomic, strong) NSMutableArray *videoSearchDocuments;
@property (nonatomic, strong) NSMutableArray *textSearchDocuments;

@property (nonatomic, strong) IAJsonDataService *audioService;
@property (nonatomic, strong) IAJsonDataService *videoService;
@property (nonatomic, strong) IAJsonDataService *textService;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, weak) IBOutlet UIToolbar *topToolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *homeBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *mediaBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *favoritesBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *questionBarButtonItem;

@property (nonatomic, weak) IBOutlet UIToolbar *secondTopToolbar;


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
        
        audioService = [[IAJsonDataService alloc] initForAllCollectionItemsWithCollectionIdentifier:@"audio" sortType:IADataServiceSortTypeTitleAscending];
        videoService = [[IAJsonDataService alloc] initForAllCollectionItemsWithCollectionIdentifier:@"movies AND NOT COLLECTION:tvarchive" sortType:IADataServiceSortTypeTitleAscending];
        textService = [[IAJsonDataService alloc] initForAllCollectionItemsWithCollectionIdentifier:@"texts" sortType:IADataServiceSortTypeTitleAscending];

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



//    for(UIBarButtonItem *item in @[self.favoritesBarButtonItem, self.questionBarButtonItem])
//    {
//        [item setTitleTextAttributes:@{NSFontAttributeName : ICONOCHIVE_FONT} forState:UIControlStateNormal];
//    }

//    [self.favoritesBarButtonItem setTitle:FAVORITE];
//    [self.mediaBarButtonItem setTitle:MEDIAPLAYER];
//    [self.questionBarButtonItem setTitle:QUESTION];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefreshing) name:@"EndRefreshing" object:nil];

    
    [audioService fetchData];
    [videoService fetchData];
    [textService fetchData];
    [navTable setScrollsToTop:NO];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [navTable addSubview:refreshControl];
    [refreshControl setTintColor:[UIColor whiteColor]];

    
}
- (IBAction)goHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopToHome" object:nil];

}

- (IBAction)goFavorites:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFavorites" object:nil];
}

- (IBAction)goMediaPlayer:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}

- (IBAction)goCredits:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenCredits" object:nil];

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
            return 2;
            break;
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
    MainNavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == 0 ? @"aboutCell" : @"mainNavCell"];
    [cell.navImageView setArchiveImage:nil];

    [cell.navImageView setHidden:YES];
    [cell.navImageView setBackgroundColor:[UIColor whiteColor]];
    [cell.fontLabel setHidden:YES];

    ArchiveSearchDoc *doc;
    switch (indexPath.section) {
        case 1:
            doc = [audioSearchDocuments objectAtIndex:indexPath.row];
            cell.fontLabel.hidden = YES;
            break;
        case 2:
            doc = [videoSearchDocuments objectAtIndex:indexPath.row];
            cell.fontLabel.hidden = YES;
            break;
        case 3:
            doc = [textSearchDocuments objectAtIndex:indexPath.row];
            cell.fontLabel.hidden = YES;
            break;
        default:
            break;
    }

    if (indexPath.section != 0) {
        
        [cell.navCellTitleLabel setHidden:NO];
        [cell.navImageView setHidden:NO];
        [cell.navCellTitleLabel setText:doc.title];
        [cell.navImageView setArchiveImage:doc.archiveImage];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    } else
    {
        if(indexPath.row == 0)
        {
            cell.navCellTitleLabel.hidden = NO;
            cell.navCellTitleLabel.text = @"Favorites";
            cell.typeLabel.text = FAVORITE;
        }
        else if (indexPath.row == 1)
        {
            cell.navCellTitleLabel.hidden = NO;
            cell.navCellTitleLabel.text = @"About";
            cell.typeLabel.text = @"i";


        }
    }
    return cell;
}


- (void) setArchiveIconForCell:(MainNavTableViewCell *)cell titleName:(NSString *)titleName
{
    cell.fontLabel = [[UILabel alloc] initWithFrame:cell.imageView.bounds];
    cell.fontLabel.text = titleName;
    [cell.fontLabel setFont:[UIFont fontWithName:@"Iconochive-Regular" size:30]];
    [cell.fontLabel setTextColor:[UIColor whiteColor]];
    [cell.fontLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:cell.fontLabel];
    CGRect f = cell.fontLabel.frame;
    f.origin.x = 5;
    f.origin.y = 0;
    f.size.height = 44;
    f.size.width = 44;
    cell.fontLabel.frame = f;
    cell.fontLabel.center = CGPointMake(cell.fontLabel.center.x, cell.paddedView.center.y);



}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {

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





- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MainNavTableViewHeaderViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"mainNavSectionHeader"];

    NSString *audioString = [NSString stringWithFormat:@"%@ %@", AUDIO, @"Audio"];
    NSMutableAttributedString *audioAtt = [[NSMutableAttributedString alloc] initWithString:audioString];
    [audioAtt addAttribute:NSForegroundColorAttributeName value:AUDIO_COLOR range:NSMakeRange(0, AUDIO.length)];
    [audioAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:ICONOCHIVE size:20] range:NSMakeRange(0, AUDIO.length)];


    NSString *videoString = [NSString stringWithFormat:@"%@ %@", VIDEO, @"Video"];
    NSMutableAttributedString *videoAtt = [[NSMutableAttributedString alloc] initWithString:videoString];
    [videoAtt addAttribute:NSForegroundColorAttributeName value:VIDEO_COLOR range:NSMakeRange(0, VIDEO.length)];
    [videoAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:ICONOCHIVE size:20] range:NSMakeRange(0, VIDEO.length)];


    NSString *bookString = [NSString stringWithFormat:@"%@ %@", BOOK, @"Texts"];
    NSMutableAttributedString *bookAtt = [[NSMutableAttributedString alloc] initWithString:bookString];
    [bookAtt addAttribute:NSForegroundColorAttributeName value:BOOK_COLOR range:NSMakeRange(0, BOOK.length)];
    [bookAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:ICONOCHIVE size:20] range:NSMakeRange(0, BOOK.length)];


    switch (section) {

        case 1:
            headerCell.sectionLabel.attributedText =  audioAtt;
            break;
        case 2:
            headerCell.sectionLabel.attributedText =  videoAtt ;
            break;
        case 3:
            headerCell.sectionLabel.attributedText =  bookAtt;
            break;
        default:
            headerCell.sectionLabel.text =  @"";
            break;
    }
    
    if(section == 0)
    {
        return nil;
    }

    return headerCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 44 : 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : UITableViewAutomaticDimension;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArchiveSearchDoc *doc;
    switch (indexPath.section) {
            case 0:
            if (indexPath.row == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFavorites" object:nil];
            } else if(indexPath.row == 1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenCredits" object:nil];
            }
            break;
        case 1:
            doc = [audioSearchDocuments objectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavCellNotification" object:doc];
            break;
        case 2:
            doc = [videoSearchDocuments objectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavCellNotification" object:doc];
            break;
        case 3:
            doc = [textSearchDocuments objectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NavCellNotification" object:doc];
            break;
        default:
            break;
    }
    
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    return NO;
}


- (void)viewDidLayoutSubviews
{

    [self.topToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.secondTopToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
 
    [self.topToolbar setClipsToBounds:YES];
    [self.secondTopToolbar setClipsToBounds:YES];

    
    [super viewDidLayoutSubviews];
}



@end
