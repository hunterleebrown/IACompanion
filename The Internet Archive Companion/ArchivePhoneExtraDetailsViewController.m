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
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:_metadata];
    [self.metadataTableView setMetadata:mut];

    [_description setDelegate:self];
    

    _description.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _description.layer.borderWidth = 5.0f;
    


}

- (void) viewWillAppear:(BOOL)animated{


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

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
   
        
        return NO;
 
    
    } else {
        return YES;
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}


@end
