//
//  ArchivePhoneExtraDetailsViewController.m
//  IA
//
//  Created by Hunter Brown on 2/21/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchivePhoneExtraDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ArchivePhoneExtraDetailsViewController () {

}

@end

@implementation ArchivePhoneExtraDetailsViewController

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
    
    [self loadWebView:_webContent];
    [self.metadataTableView setMetadata:_metadata];
    
    
    

    _description.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _description.layer.borderWidth = 5.0f;
    
}

- (void) setWebContent:(NSString *)webContent{
    _webContent = webContent;
}

- (void) setMetadata:(NSMutableDictionary *)metadata{
    _metadata = metadata;
}


- (void) loadWebView:(NSString *)description{
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [_description loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
             MIMEType:@"text/html"
     textEncodingName:@"UTF-8"
              baseURL:theBaseURL];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
