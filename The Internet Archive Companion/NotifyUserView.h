//
//  NotifyUserView.h
//  IA
//
//  Created by Hunter on 3/8/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyUserView : UIView

@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UIButton *okayButton;


- (void)show;


@end
