//
//  HomeCombinedViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeScrollView.h"

@interface HomeCombinedViewController : UIViewController<UIScrollViewDelegate>


@property (nonatomic, assign) IBOutlet HomeScrollView *contentScrollView;


@end
