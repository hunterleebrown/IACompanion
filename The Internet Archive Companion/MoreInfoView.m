//
//  MoreInfoView.m
//  IA
//
//  Created by Hunter Brown on 2/26/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MoreInfoView.h"

@implementation MoreInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        

        
        
    }
    return self;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        
        UIViewController *pop = [UIViewController new];
        UIWebView *popWeb = [UIWebView new];
        [popWeb setScalesPageToFit:YES];
        [popWeb loadRequest:request];
        pop.view = popWeb;
        [pop setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [_parentController presentViewController:pop animated:YES completion:nil];
        
        
        return NO;
    }
    return YES;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
