//
//  ItemContentViewController.m
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ItemContentViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ItemContentViewController ()

@end

@implementation ItemContentViewController

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
    
    
    self.archiveDescription = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.archiveDescription.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.archiveDescription setBackgroundColor:[UIColor clearColor]];
    [self.archiveDescription setOpaque:NO];
    
}

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    //ArchiveDetailDoc *doc = ((IAJsonDataService *)service).rawResults
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    ArchiveDetailDoc *doc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    self.titleLabel.text = doc.title;
    if(doc.archiveImage){
        [self.imageView setArchiveImage:doc.archiveImage];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 88, self.tableHeaderView.frame.size.width, self.tableHeaderView.frame.size.height - 88);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] CGColor], (id)[[UIColor blackColor] CGColor], nil];
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
        [self.popUpView showWithSubView:self.archiveDescription];
        
    } else {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
