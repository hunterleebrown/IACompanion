//
//  HomeScrollView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNavTableView.h"
#import "HomeContentParentView.h"

@interface HomeScrollView : UIScrollView


@property (nonatomic, weak) IBOutlet HomeContentParentView *homeContentView;
@property (nonatomic, weak) IBOutlet UIView *homeNavView;
@property (nonatomic, weak) IBOutlet HomeNavTableView *homeNavTableView;

@end
