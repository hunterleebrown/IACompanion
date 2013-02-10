//
//  HomeContentParentView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/10/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeContentTableView.h"
#import "HomeNavTableView.h"



@interface HomeContentParentView : UIView<UIWebViewDelegate, HomeNavTouchDelegate>

@property (weak, nonatomic) IBOutlet HomeContentTableView *homeContentTableView;
@property (weak, nonatomic) IBOutlet UIWebView *homeContentDescriptionView;

@end
