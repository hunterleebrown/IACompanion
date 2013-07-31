//
//  PopUpViewController.h
//  IA
//
//  Created by Hunter on 7/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController


- (void) showWithSubView:(UIView *)view title:(NSString *)title message:(NSString *)message;
- (void) dismiss;
@property (assign) BOOL expanded;


@end
