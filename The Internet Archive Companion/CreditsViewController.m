//
//  CreditsViewController.m
//  IA
//
//  Created by Hunter Brown on 3/13/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *creditsWebView;
@property (nonatomic, weak) IBOutlet UIButton *okayButton;
@property (nonatomic, strong) NSURL *externalUrl;

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.



    NSString *content = @"<span xmlns:dct=\"http://purl.org/dc/terms/\" href=\"http://purl.org/dc/dcmitype/InteractiveResource\" property=\"dct:title\" rel=\"dct:type\">Internet Archive Companion</span> <p>by <a xmlns:cc=\"http://creativecommons.org/ns#\" href=\"http://www.hunterleebrown.com/IACompanion\" property=\"cc:attributionName\" rel=\"cc:attributionURL\">Hunter Lee Brown</a> </p><p>is licensed under a <a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc/3.0/deed.en_US\">Creative Commons Attribution-NonCommercial 3.0 Unported License</a>.</p><p><a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc/3.0/deed.en_US\"><img alt=\"Creative Commons License\" style=\"border-width:0\" src=\"http://i.creativecommons.org/l/by-nc/3.0/88x31.png\" /></a></p><p>This application was not produced by nor is it officially associated with <a href=\"http://archive.org/about\">The Internet Archive</a>.</p>";
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}body{text-align:center;}</style></head><body style='padding-top:100px; background-color:#ffffff; color:#000; font-size:14px; font-family:\"Helvetica\"'>%@<p>Internet Archive Companion, version %@</p><br/><p>You can leave comments and email messages via this support <a href=\"http://www.hunterleebrown.com/IACompanion\">link</a>.</p></body></html>", content, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    
    [self.creditsWebView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                  MIMEType:@"text/html"
          textEncodingName:@"UTF-8"
                   baseURL:[NSURL URLWithString:@"http://"]];
    
    
    [self.creditsWebView.scrollView setScrollEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        self.externalUrl = request.URL;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Web Page" message:@"Do you want to view this web page with Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        return NO;
    }
    return YES;

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:self.externalUrl];
        
    }
}


- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
