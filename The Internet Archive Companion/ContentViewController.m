//
//  ContnetViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "FontMapping.h"
#import "ContentViewController.h"
#import "ArchiveSearchDoc.h"
#import "ItemContentViewController.h"
#import "PopUpView.h"
#import "ArchiveCollectionViewControllerHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchCollectionViewCell.h"
#import "IAJsonDataService.h"
#import "SorterView.h"
#import "LayoutChangerView.h"

@interface ContentViewController () <IADataServiceDelegate, UISearchBarDelegate, UIAlertViewDelegate, UIToolbarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)  UIWebView *moreInfoView;

@property (nonatomic, strong) NSURL *externalUrl;
@property (nonatomic, weak) IBOutlet UIButton *creditsButton;

@property (nonatomic, weak) IBOutlet UIView *listIconButton;
@property (nonatomic, weak) IBOutlet UIView *playerIconButton;
@property (nonatomic, weak) IBOutlet UIView *searchIconButton;
@property (nonatomic, weak) IBOutlet UIView *favoritesIconButton;
@property (nonatomic, weak) IBOutlet UIImageView *iaIcon;

@property (nonatomic, weak) IBOutlet UILabel *topArchiveLogo;

@property (nonatomic, weak) IBOutlet UIImageView *bwArchiveImage;

@property (nonatomic, weak) IBOutlet UICollectionView *picksCollectionView;
@property (nonatomic, strong) NSMutableArray *searchDocuments;

@property (nonatomic, weak) IBOutlet LayoutChangerView *layoutChangerView;

@property (assign) NSInteger numFound;
@property (assign) NSInteger start;
@property (assign) BOOL didTriggerLoadMore;

@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, weak) IBOutlet SorterView *sorterView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *searchFilters;


@end

@implementation ContentViewController
@synthesize service, popUpView, archiveDescription, tableHeaderView, metaDataTable, externalUrl;
@synthesize detDoc, moreInfoView, listIconButton, playerIconButton, searchIconButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    [self.homeListButton setTitle:HAMBURGER forState:UIControlStateNormal];
    [self.homeSearchButton setTitle:SEARCH forState:UIControlStateNormal];
    [self.homeMediaPlayerButton setTitle:MEDIAPLAYER forState:UIControlStateNormal];
    [self.homeFavoritesButton setTitle:FAVORITE forState:UIControlStateNormal];

    [self.topArchiveLogo setText:ARCHIVE];

    
    if(self.bwArchiveImage)
    {
        [self doParalax];
    }



    _listButton = [[UIBarButtonItem alloc] initWithTitle:ARCHIVE style:UIBarButtonItemStylePlain target:self action:@selector(didPressListButton)];
    [_listButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];
    


    _searchButton = [[UIBarButtonItem alloc] initWithTitle:SEARCH style:UIBarButtonItemStylePlain target:self action:@selector(didPressSearchButton)];
    [_searchButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];

    


    _mpBarButton = [[UIBarButtonItem alloc] initWithTitle:MEDIAPLAYER style:UIBarButtonItemStylePlain target:self action:@selector(didPressMPButton)];
    [_mpBarButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];


    [self.navigationItem setRightBarButtonItems:@[_searchButton, _mpBarButton]];
    
    
    popUpView = [[PopUpView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:popUpView];
    
    metaDataTable = [[MetaDataTable alloc] initWithFrame:CGRectZero];
    
    
    NSString *content = @"<span xmlns:dct=\"http://purl.org/dc/terms/\" href=\"http://purl.org/dc/dcmitype/InteractiveResource\" property=\"dct:title\" rel=\"dct:type\">Internet Archive Companion</span> <p>by <a xmlns:cc=\"http://creativecommons.org/ns#\" href=\"http://www.hunterleebrown.com/IACompanion\" property=\"cc:attributionName\" rel=\"cc:attributionURL\">Hunter Lee Brown</a> </p><p>is licensed under a <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc/3.0/deed.en_US\">Creative Commons Attribution-NonCommercial 3.0 Unported License</a>.</p><p><a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc/3.0/deed.en_US\"><img alt=\"Creative Commons License\" style=\"border-width:0\" src=\"http://i.creativecommons.org/l/by-nc/3.0/88x31.png\" /></a></p><p>This application was not produced by nor is it officially associated with <a href=\"http://archive.org/about\">The Internet Archive</a>.</p>";
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}body{text-align:center;}</style></head><body style='background-color:#ffffff; color:#000; font-size:14px; font-family:\"Helvetica\"'>%@<p>Internet Archive Companion, version %@</p></body></html>", content, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    
    
    moreInfoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [moreInfoView setDelegate:self];
    
    [moreInfoView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                              MIMEType:@"text/html"
                      textEncodingName:@"UTF-8"
                               baseURL:nil];
    
    
    [moreInfoView.scrollView setScrollEnabled:NO];
    [self.archiveDescription setScalesPageToFit:YES];
    
    self.middleWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

    if(self.favoritesButton)
    {
        [self.favoritesButton setTitle:FAVORITE forState:UIControlStateNormal];
    }

    if(self.shareButton)
    {
        [self.shareButton setTitle:SHARE forState:UIControlStateNormal];
    }

    if(self.wwwButton)
    {
        [self.wwwButton setTitle:GLOBE forState:UIControlStateNormal];
    }

    if(self.folderButton)
    {
        [self.folderButton setTitle:FOLDER forState:UIControlStateNormal];
    }

    if(self.collectionButton)
    {
        [self.collectionButton setTitle:COLLECTION forState:UIControlStateNormal];
    }

    if(self.itemToolbar)
    {
//        [self.itemToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [self.itemToolbar setBackgroundColor:[UIColor clearColor]];
        self.itemToolbar.clipsToBounds = YES;
    }

    self.searchDocuments = [NSMutableArray new];


    if(![self.title isEqualToString:@"ITEM"]) {
        self.service = [[IAJsonDataService alloc] initWithAllPicks];
        self.service.delegate = self;
        [self.service fetchData];
        [self.sorterView setService:self.service];
        [self.navigationItem setLeftBarButtonItems:@[_listButton]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

    }

    [self.searchFilters setTitleTextAttributes:@{NSFontAttributeName : ICONOCHIVE_FONT, NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];

    [self.searchFilters setTitle:ARCHIVE forSegmentAtIndex:0];
    [self.searchFilters setTitle:AUDIO forSegmentAtIndex:1];
    [self.searchFilters setTitle:VIDEO forSegmentAtIndex:2];
    [self.searchFilters setTitle:BOOK  forSegmentAtIndex:3];
    [self.searchFilters setTitle:IMAGE forSegmentAtIndex:4];



    [self.sorterView.relevanceButton setHidden:YES];
    CGRect fr = self.sorterView.relevanceButton.frame;
    fr.size.width = 0;
    self.sorterView.relevanceButton.frame = fr;

    self.sorterView.selectedButton = self.sorterView.dateButton;
    self.sorterView.selectedButton.selected = YES;
    self.sorterView.selectedSortType = IADataServiceSortTypeDateDescending;
    [self.sorterView readyDateButton];

   // [self.sorterView.toolbar setItems:@[self.sorterView.dateButton, self.sorterView.titleButton, self.sorterView.viewsButton]];

}


#pragma mark - data

- (NSString *)filterQueryParam
{

    NSInteger selectedSegment = self.searchFilters.selectedSegmentIndex;
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

    NSString *extraSearchParam = [self filterQueryParam];

        [self.sorterView resetSortButtons];

        service = [[IAJsonDataService alloc] initWithQueryString:[NSString stringWithFormat:@"+pick:1%@",  extraSearchParam]];
        [self.sorterView setService:service];

        [service setDelegate:self];
        [service fetchData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

}



- (void) dataDidBecomeAvailableForService:(IADataService *)serv {

    [self.sorterView serviceDidReturn];



    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];

    if(service.rawResults && [service.rawResults objectForKey:@"documents"]){

        if(!self.didTriggerLoadMore) {
            [self.searchDocuments removeAllObjects];
        }
        [self.searchDocuments addObjectsFromArray:[service.rawResults objectForKey:@"documents"]];
        self.numFound  = [[service.rawResults objectForKey:@"numFound"] intValue];

        [self.picksCollectionView reloadData];

        if(!self.didTriggerLoadMore) {
            [self.picksCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    self.didTriggerLoadMore = NO;
    [self.picksCollectionView setHidden:NO];
}


#pragma mark - load more

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > scrollView.contentSize.height * 0.5)
    {
        if(self.searchDocuments.count > 0  && self.searchDocuments.count < self.numFound  && self.start < self.numFound && !self.didTriggerLoadMore){
            [self loadMoreItems:nil];
        }
    }
}

- (void)loadMoreItems:(id)sender {
    if(self.numFound > 50) {
        self.didTriggerLoadMore = YES;
        self.start = self.start + 50;

        [self.service setLoadMoreStart:[NSString stringWithFormat:@"%li", (long)self.start]];
        [self.service fetchData];

    }
}

#pragma mark -



#pragma mark - collection view

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.searchDocuments count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [self.searchDocuments objectAtIndex:indexPath.row];
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];

    [cell setArchiveSearchDoc:doc];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [self.searchDocuments objectAtIndex:indexPath.row];
    ItemContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
    [cvc setSearchDoc:doc];
    [self.navigationController pushViewController:cvc animated:YES];


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveSearchDoc *doc = [self.searchDocuments objectAtIndex:indexPath.row];
//    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
//    [cell setCellLayoutStyle:self.layoutChangerView.cellLayoutStyle];
    return [SearchCollectionViewCell sizeForOrientation:self.interfaceOrientation collectionView:collectionView cellLayoutStyle:self.layoutChangerView.cellLayoutStyle archiveDoc:doc];
}






#pragma mark -

- (void) doParalax
{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.bwArchiveImage addMotionEffect:group];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        
//        if(webView == self.middleWebView){
//            externalUrl = request.URL;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//            [alert show];
//            return NO;
//        }
        
        NSString *detailURL;
        
        NSArray *slashes = [urlString componentsSeparatedByString:@"/"];
     
        for(int i=0; i < [slashes count]; i++){
            NSString *slash = [slashes objectAtIndex:i];
            NSRange textRange;
            textRange = [slash rangeOfString:@"details"];
     
            if(textRange.location != NSNotFound) {
                NSString *secondSlash = [slashes objectAtIndex:i+1];
                if([secondSlash rangeOfString:@"#"].length != 0)
                {
                    externalUrl = request.URL;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                    [alert show];
                    return NO;
                }

                NSLog(@"  second slash: %@", secondSlash);
                NSString *identifier = [slashes objectAtIndex:i+1];
                ArchiveSearchDoc *doc = [ArchiveSearchDoc new];
                doc.identifier = identifier;
                doc.type = MediaTypeAny;
                ArchiveCollectionViewControllerHelper *helper = [ArchiveCollectionViewControllerHelper new];
                [helper setSearchDoc:doc];
                return NO;
            }
            
        }
        if(detailURL){
            
        } else {
            externalUrl = request.URL;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            
        }
        return NO;
    }
    return YES;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:externalUrl];

    }
}



- (IBAction)didPressFavorites
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenFavorites" object:nil];

}

- (IBAction)didPressSearchButton{
    
    /*
    if(self.searchIsShowing){
        [self hideSearch];
    } else {
        
        [self showSearch];
    }
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewController" object:nil];
    
}


- (IBAction)didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];
}






- (IBAction)showSharingActionsSheet:(id)sender{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://archive.org/details/%@", self.detDoc.identifier]];
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    if([shareViewController respondsToSelector:@selector(popoverPresentationController)]){
        [shareViewController.popoverPresentationController setSourceView:sender];
    }
    [self presentViewController:shareViewController animated:YES completion:nil];
    
}


- (IBAction) didPressMPButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}


- (IBAction)showWeb:(id)sender
{
    externalUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://archive.org/details/%@", self.detDoc.identifier]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction) showPopUp:(id)sender{
    
    if(((UIButton *)sender).tag == 0){
        [self.popUpView showWithSubView:self.archiveDescription title:@"About" message:nil];
        
        
//        if(self.middleWebViewHeight.constant == 0) {
//            self.middleWebViewHeight.constant = 200;
//            self.upperViewHeight.constant += self.middleWebViewHeight.constant;
//        } else {
//            self.middleWebViewHeight.constant = 0;
//            self.upperViewHeight.constant = 220;
//
//        }
//        [self.middleWebView setNeedsUpdateConstraints];
//        [self.tableHeaderView setNeedsUpdateConstraints];
//        
//        [UIView animateWithDuration:0.33 animations:^{
//            [self.view layoutIfNeeded];
//        }];
        
        
    } else if (((UIButton *)sender).tag == 1) {
        [self.popUpView showWithSubView:self.metaDataTable title:@"MetaData" message:nil];
    } else if (((UIButton *)sender).tag == 2) {
        externalUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://archive.org/details/%@", self.detDoc.identifier]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    } else if (((UIButton *)sender).tag == 3) {
        [self.popUpView showWithSubView:moreInfoView title:@"Credits" message:nil];
    } else if (((UIButton *)sender).tag == 4) {
        externalUrl = [NSURL URLWithString:@"http://blog.archive.org"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}













- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [UIView animateWithDuration:0.35 animations:^{
        [popUpView setFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height)];
    }];

    [self.picksCollectionView.collectionViewLayout invalidateLayout];


}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
