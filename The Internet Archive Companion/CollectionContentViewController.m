//
//  CollectionContentViewController.m
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CollectionContentViewController.h"
#import "CollectionDataHandlerAndHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface CollectionContentViewController () 

@property (nonatomic, weak) IBOutlet CollectionDataHandlerAndHeaderView *collectionHandlerView;


@end

@implementation CollectionContentViewController
@synthesize collectionHandlerView;

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
   
    [self.navigationItem setLeftBarButtonItems:@[self.listButton, self.mpBarButton, self.searchButton, self.backButton]];
    [self.service fetchData];
    
    [collectionHandlerView setIdentifier:self.searchDoc.identifier];
    [collectionHandlerView.collectionTableView setScrollsToTop:YES];
    
    self.archiveDescription = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.archiveDescription.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.archiveDescription setBackgroundColor:[UIColor clearColor]];
    [self.archiveDescription setOpaque:NO];
    [self.archiveDescription setDelegate:self];


    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [collectionHandlerView.collectionTableView deselectRowAtIndexPath:collectionHandlerView.collectionTableView.indexPathForSelectedRow animated:YES];
    
    
    
}


- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    self.detDoc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    self.titleLabel.text = self.detDoc.title;
    if(self.detDoc.archiveImage){
        [self.imageView setArchiveImage:self.detDoc.archiveImage];
    }
    

    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#000;  font-family:\"Helvetica\";'>%@</body></html>", self.detDoc.details];
    
    [self setTitle:self.detDoc.title];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSFontAttributeName, nil]];
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    
    
    [self.archiveDescription loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
             MIMEType:@"text/html"
     textEncodingName:@"UTF-8"
              baseURL:theBaseURL];
    
    
//    [self.middleWebView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
//                             MIMEType:@"text/html"
//                     textEncodingName:@"UTF-8"
//                              baseURL:theBaseURL];
    
    
    
    [self.metaDataTable addMetadata:[self.detDoc.rawDoc objectForKey:@"metadata"]];
    
}





- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
