//
//  PopUpView.h
//  IA
//
//  Created by Hunter Brown on 7/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView


- (void) showWithSubView:(UIView *)view title:(NSString *)title message:(NSString *)message;
- (void) dismiss;
@property (assign) BOOL expanded;
@end
