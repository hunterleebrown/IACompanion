//
//  ContnetViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ContentViewController.h"
#import "ArchiveSearchDoc.h"
#import "CollectionContentViewController.h"
#import "ItemContentViewController.h"
#import "PopUpView.h"

@interface ContentViewController () <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *moreInfoView;


@end

@implementation ContentViewController
@synthesize service, popUpView, archiveDescription, tableHeaderView, metaDataTable, detDoc, moreInfoView;

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
    
    UIImage *image = [UIImage imageNamed:@"new-list.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 10, image.size.height);
    button.tag = 0;
    [button addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    _listButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    
    UIImage *image2 = [UIImage imageNamed:@"search-button-plain.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, image2.size.width + 10, image2.size.height);
    button2.tag = 0;
   // [button2 addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:image2 forState:UIControlStateNormal];
    _searchButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
    UIImage *bi = [UIImage imageNamed:@"back-button.png"];
    UIButton *bibutton = [UIButton buttonWithType:UIButtonTypeCustom];
    bibutton.frame = CGRectMake(0, 0, bi.size.width, bi.size.height);
    bibutton.tag = 0;
    [bibutton addTarget:self action:@selector(didPressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [bibutton setImage:bi forState:UIControlStateNormal];
    
    _backButton = [[UIBarButtonItem alloc] initWithCustomView:bibutton];
    
    [self.navigationItem setLeftBarButtonItems:@[_listButton]];


    [self.navigationItem setRightBarButtonItems:@[_searchButton]];
    
    
    popUpView = [[PopUpView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:popUpView];
    
    metaDataTable = [[MetaDataTable alloc] initWithFrame:CGRectZero];
    
    
    NSString *content = @"<a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc/3.0/deed.en_US\"><img alt=\"Creative Commons License\" style=\"border-width:0\" src=\"http://i.creativecommons.org/l/by-nc/3.0/88x31.png\" /></a><br /><span xmlns:dct=\"http://purl.org/dc/terms/\" href=\"http://purl.org/dc/dcmitype/InteractiveResource\" property=\"dct:title\" rel=\"dct:type\">Internet Archive Companion</span> <p>by <a xmlns:cc=\"http://creativecommons.org/ns#\" href=\"http://www.hunterleebrown.com/IACompanion\" property=\"cc:attributionName\" rel=\"cc:attributionURL\">Hunter Lee Brown</a> </p><p>is licensed under a <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc/3.0/deed.en_US\">Creative Commons Attribution-NonCommercial 3.0 Unported License</a>.</p><p>This application was not produced by nor is it officially associated with <a href=\"http://archive.org/about\">The Internet Archive</a>.</p>";
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}body{text-align:center;}</style></head><body style='background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@<p>Internet Archive Companion, version %@</p></body></html>", content, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    
    
    
    
    [moreInfoView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                              MIMEType:@"text/html"
                      textEncodingName:@"UTF-8"
                               baseURL:nil];
    
    
    [moreInfoView.scrollView setScrollEnabled:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
       [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}


- (IBAction) showPopUp:(id)sender{
    
    if(((UIButton *)sender).tag == 0){
        [self.popUpView showWithSubView:self.archiveDescription title:@"Description" message:nil];
    } else if (((UIButton *)sender).tag == 1) {
        [self.popUpView showWithSubView:self.metaDataTable title:@"MetaData" message:nil];
    }
}

- (void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];

}

- (void) setSearchDoc:(ArchiveSearchDoc *)searchDoc{
    _searchDoc = searchDoc;
    self.service = [[IAJsonDataService alloc] initForMetadataDocsWithIdentifier:_searchDoc.identifier];
    [self.service setDelegate:self];
    
    
}



- (void) didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];    
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
