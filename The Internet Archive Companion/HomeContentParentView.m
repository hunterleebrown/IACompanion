//
//  HomeContentParentView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/10/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeContentParentView.h"

@implementation HomeContentParentView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        

        
    }
    return self;

}

- (IBAction)toggleContent:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveOverNotification" object:nil];
    if(self.homeContentDescriptionView.bounds.size.height > 0){
        [self toggleDetails:nil];
    }
    if(_searchButtonHolder){
        [self showSearchButtons];
    }
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_toolBarTitle setTitle:@""];
    [_homeContentTableView setDidTriggerLoadMore:NO];    
    MediaType type = (MediaType)_searchButtons.selectedSegmentIndex;
    [_homeContentTableView.service getDocsWithQueryString:searchBar.text forMediaType:type];
    [_detailsButton setEnabled:NO];
    [self hideSplashView];
    
    if(_searchButtonHolder){
        [self hideSearchButtons];
    }
    
    
}





    
    


- (void) showSearchButtons{
    [UIView animateWithDuration:0.33 animations:^{
        [_searchButtonHolder setFrame:CGRectMake(0, 44, _searchButtonHolder.bounds.size.width, _searchButtonHolder.bounds.size.height)];
    } completion:^(BOOL finished) {
       
    }];
}

- (void) hideSearchButtons{
    [UIView animateWithDuration:0.33 animations:^{
        [_searchButtonHolder setFrame:CGRectMake(0, 0, _searchButtonHolder.bounds.size.width, _searchButtonHolder.bounds.size.height)];
    } completion:^(BOOL finished) {
        
    }];

}

- (void) hideSplashView{
    if(!_iAHomeSplashView.hidden){
        [UIView animateWithDuration:0.33 animations:^{
            [_iAHomeSplashView setFrame:CGRectMake(_iAHomeSplashView.frame.origin.x,
                                                    self.bounds.size.height,
                                                    _iAHomeSplashView.bounds.size.width,
                                                    _iAHomeSplashView.bounds.size.height)];
        } completion:^(BOOL finished) {
            [_iAHomeSplashView setHidden:YES];
        }];
    }
}


- (IBAction) showSplashView{
    if(_iAHomeSplashView.hidden){
        [_iAHomeSplashView setHidden:NO];

        
        [UIView animateWithDuration:0.33 animations:^{
            [_iAHomeSplashView setFrame:CGRectMake(_iAHomeSplashView.frame.origin.x,
                                                   44,
                                                   _iAHomeSplashView.bounds.size.width,
                                                   _iAHomeSplashView.bounds.size.height)];
        } completion:^(BOOL finished) {
            
            [_aSearchBar resignFirstResponder];
            if(_searchButtonHolder){
                [self hideSearchButtons];
            }
            
            NSURL *blogUrl = [NSURL URLWithString:@"http://blog.archive.org/category/announcements/"];
            NSURLRequest *req = [[NSURLRequest alloc] initWithURL:blogUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
            [_iABlogWebView loadRequest:req];
        }];
    }
}

- (IBAction)toggleSplashView:(id)sender {
    _iAHomeSplashView.hidden ? [self showSplashView] : [self hideSplashView];
}



- (void) didScroll{
    if(self.homeContentDescriptionView.bounds.size.height > 0){
        [self toggleDetails:nil];
    }
    [_aSearchBar resignFirstResponder];
    if(_searchButtonHolder){
        [self hideSearchButtons];
    }
}




- (IBAction)toggleDetails:(id)sender{

    [UIView animateWithDuration:0.33 animations:^{
        if(self.homeContentDescriptionView.bounds.size.height == 0){

            [self.homeContentDescriptionView setHidden:NO];

            [self.homeContentDescriptionView setFrame:CGRectMake(self.homeContentDescriptionView.frame.origin.x,
                                                                 self.homeContentDescriptionView.frame.origin.y,
                                                                 self.homeContentDescriptionView.bounds.size.width,
                                                                 self.bounds.size.height - 88)];

                    
        } else {
            [self.homeContentDescriptionView setFrame:CGRectMake(self.homeContentDescriptionView.frame.origin.x,
                                                                 self.homeContentDescriptionView.frame.origin.y,
                                                                 self.homeContentDescriptionView.bounds.size.width,
                                                                 0)];            
            

             }
        
    } completion:^(BOOL finished) {
        [self.homeContentDescriptionView setHidden:self.homeContentDescriptionView.bounds.size.height == 0];
        

    }];


}


- (void) fadeInInstructions{
    [_instructionsView setHidden:NO];
    [UIView animateWithDuration:0.33 animations:^{
        [_instructionsView setAlpha:0.9];
    }];
}


- (void) fadeOutInstructions{
    [UIView animateWithDuration:0.33 animations:^{
        [_instructionsView setAlpha:0];
    } completion:^(BOOL finished) {
        [_instructionsView setHidden:YES];
    }];

}

- (IBAction)toggleInstructions:(id)sender{
    _instructionsView.hidden ? [self fadeInInstructions] : [self fadeOutInstructions];
}


#pragma marks - WebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if(webView == _iABlogWebView){
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
    
}


@end
