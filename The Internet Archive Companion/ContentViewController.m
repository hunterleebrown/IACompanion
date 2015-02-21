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
#import "CollectionContentViewController.h"
#import "ItemContentViewController.h"
#import "PopUpView.h"
#import "ArchiveCollectionViewControllerHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface ContentViewController () <UISearchBarDelegate, UIAlertViewDelegate, UIToolbarDelegate>
@property (nonatomic, strong)  UIWebView *moreInfoView;

@property (nonatomic, strong) NSURL *externalUrl;
@property (nonatomic, weak) IBOutlet UIButton *creditsButton;

@property (nonatomic, weak) IBOutlet UIView *listIconButton;
@property (nonatomic, weak) IBOutlet UIView *playerIconButton;
@property (nonatomic, weak) IBOutlet UIView *searchIconButton;
@property (nonatomic, weak) IBOutlet UIView *favoritesIconButton;
@property (nonatomic, weak) IBOutlet UIImageView *iaIcon;

@property (nonatomic, weak) IBOutlet UILabel *topArchiveLogo;

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





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    
////    UIImage *image = [UIImage imageNamed:@"new-list.png"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////    button.frame = CGRectMake(0, 0, image.size.width + 10, image.size.height);
//    [button.titleLabel setFont:[UIFont fontWithName:@"Iconochive-Regular" size:15]];
//    button.tag = 0;
//    [button setTitle:@"" forState:UIControlStateNormal]
//    [button addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
////    [button setImage:image forState:UIControlStateNormal];



    _listButton = [[UIBarButtonItem alloc] initWithTitle:HAMBURGER style:UIBarButtonItemStylePlain target:self action:@selector(didPressListButton)];
    [_listButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];
    
    UIImage *image2 = [UIImage imageNamed:@"search-button-plain.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, image2.size.width + 10, image2.size.height);
    button2.tag = 0;
    [button2 addTarget:self action:@selector(didPressSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:image2 forState:UIControlStateNormal];
//    _searchButton = [[UIBarButtonItem alloc] initWithCustomView:button2];

    _searchButton = [[UIBarButtonItem alloc] initWithTitle:SEARCH style:UIBarButtonItemStylePlain target:self action:@selector(didPressSearchButton)];
    [_searchButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];


    
    UIImage *bi = [UIImage imageNamed:@"back-button.png"];
    UIButton *bibutton = [UIButton buttonWithType:UIButtonTypeCustom];
    bibutton.frame = CGRectMake(0, 0, bi.size.width, bi.size.height);
    bibutton.tag = 0;
    [bibutton addTarget:self action:@selector(didPressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [bibutton setImage:bi forState:UIControlStateNormal];
    
    _backButton = [[UIBarButtonItem alloc] initWithCustomView:bibutton];
    

//
//    UIImage *mpi = [UIImage imageNamed:@"open-player-button.png"];
//    UIButton *mpbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    mpbutton.frame = CGRectMake(0, 0, mpi.size.width, mpi.size.height);
//    mpbutton.tag = 1;
//    [mpbutton addTarget:self action:@selector(didPressMPButton) forControlEvents:UIControlEventTouchUpInside];
//    [mpbutton setImage:mpi forState:UIControlStateNormal];
//    _mpBarButton = [[UIBarButtonItem alloc] initWithCustomView:mpbutton];
//
    _mpBarButton = [[UIBarButtonItem alloc] initWithTitle:MEDIAPLAYER style:UIBarButtonItemStylePlain target:self action:@selector(didPressMPButton)];
    [_mpBarButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Iconochive-Regular" size:30.0]} forState:UIControlStateNormal];


    [self.navigationItem setLeftBarButtonItems:@[_listButton, _mpBarButton, _searchButton]];

    
    
   // [self.navigationItem setRightBarButtonItems:@[_searchButton]];
    
    
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
    
    

    

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [listIconButton.layer setCornerRadius:10];
//    [playerIconButton.layer setCornerRadius:10];
//    [searchIconButton.layer setCornerRadius:10];
//    [self.favoritesIconButton.layer setCornerRadius:10];
//    [self.iaIcon.layer setCornerRadius:10];

    [self.homeListButton setTitle:HAMBURGER forState:UIControlStateNormal];
    [self.homeSearchButton setTitle:SEARCH forState:UIControlStateNormal];
    [self.homeMediaPlayerButton setTitle:MEDIAPLAYER forState:UIControlStateNormal];
    [self.homeFavoritesButton setTitle:HEART forState:UIControlStateNormal];

    [self.topArchiveLogo setText:ARCHIVE];

}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = request.URL.absoluteString;
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        NSString *detailURL;
        
        NSArray *slashes = [urlString componentsSeparatedByString:@"/"];
     
        for(int i=0; i < [slashes count]; i++){
            NSString *slash = [slashes objectAtIndex:i];
            NSRange textRange;
            textRange = [slash rangeOfString:@"details"];
     
            if(textRange.location != NSNotFound) {
                NSLog(@"  second slash: %@", [slashes objectAtIndex:i+1]);
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



- (void) didPressSearchButton{
    
    /*
    if(self.searchIsShowing){
        [self hideSearch];
    } else {
        
        [self showSearch];
    }
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchViewController" object:nil];
    
}







- (void) didPressMPButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}

- (IBAction) showPopUp:(id)sender{
    
    if(((UIButton *)sender).tag == 0){
        [self.popUpView showWithSubView:self.archiveDescription title:@"Description" message:nil];
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






- (void) setSearchDoc:(ArchiveSearchDoc *)searchDoc{
    _searchDoc = searchDoc;
    self.service = [[IAJsonDataService alloc] initForMetadataDocsWithIdentifier:_searchDoc.identifier];
    [self.service setDelegate:self];
    
    
}




- (void) didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];    
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [UIView animateWithDuration:0.35 animations:^{
        [popUpView setFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height)];
    }];

}



- (void) didPressBackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
