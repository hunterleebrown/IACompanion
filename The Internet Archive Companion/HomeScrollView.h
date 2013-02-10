//
//  HomeScrollView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNavTableView.h"
#import "HomeContentTableView.h"

@interface HomeScrollView : UIScrollView



@property (nonatomic, weak) IBOutlet UIView *homeNavView;
@property (nonatomic, weak) IBOutlet UIView *homeContentView;
@property (nonatomic, weak) IBOutlet HomeNavTableView *homeNavTableView;
@property (nonatomic, weak) IBOutlet HomeContentTableView *homeContentTableView;

@end
