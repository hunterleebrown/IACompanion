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

@interface CollectionContentViewController () <UIWebViewDelegate>

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
   
    [self.navigationItem setLeftBarButtonItems:@[self.listButton, self.backButton]];
    [self.service fetchData];
    
    [collectionHandlerView setIdentifier:self.searchDoc.identifier];
    [collectionHandlerView.collectionTableView setScrollsToTop:YES];
    
    self.archiveDescription = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.archiveDescription.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.archiveDescription setBackgroundColor:[UIColor clearColor]];
    [self.archiveDescription setOpaque:NO];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [collectionHandlerView.collectionTableView deselectRowAtIndexPath:collectionHandlerView.collectionTableView.indexPathForSelectedRow animated:YES];
}

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    //ArchiveDetailDoc *doc = ((IAJsonDataService *)service).rawResults
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    ArchiveDetailDoc *doc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ Collection", doc.title];
    if(doc.archiveImage){
        [self.imageView setArchiveImage:doc.archiveImage];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.tableHeaderView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [self.tableHeaderView.layer insertSublayer:gradient atIndex:1];
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#FAEBD7; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", doc.description];
    
    [self setTitle:doc.title];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16], UITextAttributeFont, nil]];
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    
    
    [self.archiveDescription loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
             MIMEType:@"text/html"
     textEncodingName:@"UTF-8"
              baseURL:theBaseURL];
    
    
}


- (IBAction) showPopUp:(id)sender{
    
    if(((UIButton *)sender).tag == 0){
        [self.popUpView showWithSubView:self.archiveDescription title:@"Description" message:nil];

    } else {
    
    }
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
