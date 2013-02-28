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




- (void) didTouchNavigationCellWithDoc:(ArchiveSearchDoc *)doc{
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='padding:20px;background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", doc.description];
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [_homeContentDescriptionView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                 MIMEType:@"text/html"
                         textEncodingName:@"UTF-8"
                                  baseURL:theBaseURL];

    [_homeContentTableView setDidTriggerLoadMore:NO];
    [_homeContentTableView.service getDocsWithCollectionIdentifier:doc.identifier];
    [_aSearchBar setText:@""];
    [_detailsButton setEnabled:YES];
    [self hideSplashView];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveOverNotification" object:nil];
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
    if(!_iASplashImageView.hidden){
        [UIView animateWithDuration:0.33 animations:^{
            [_iASplashImageView setFrame:CGRectMake(_iASplashImageView.frame.origin.x,
                                                    self.bounds.size.height,
                                                    _iASplashImageView.bounds.size.width,
                                                    _iASplashImageView.bounds.size.height)];
        } completion:^(BOOL finished) {
            [_iASplashImageView setHidden:YES];
        }];
    }
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


#pragma marks - WebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    return YES;
    
}


@end
