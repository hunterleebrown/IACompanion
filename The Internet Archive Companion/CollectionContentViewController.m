//
//  CollectionContentViewController.m
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CollectionContentViewController.h"
#import "ArchiveImageView.h"
#import "CollectionDataHandlerAndHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface CollectionContentViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *tableHeaderView;
@property (nonatomic, weak) IBOutlet ArchiveImageView *imageView;

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
    

}

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    //ArchiveDetailDoc *doc = ((IAJsonDataService *)service).rawResults
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    ArchiveDetailDoc *doc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@ Collection", doc.title];
    if(doc.archiveImage){
        [_imageView setArchiveImage:doc.archiveImage];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _tableHeaderView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [_tableHeaderView.layer insertSublayer:gradient atIndex:1];
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", doc.description];
    
    [self setTitle:doc.title];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16], UITextAttributeFont, nil]];
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    
    /*
    [_description loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
             MIMEType:@"text/html"
     textEncodingName:@"UTF-8"
              baseURL:theBaseURL];
    
    */
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
