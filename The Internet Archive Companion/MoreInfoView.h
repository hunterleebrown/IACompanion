//
//  MoreInfoView.h
//  IA
//
//  Created by Hunter Brown on 2/26/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreInfoView : UIView<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *licenseWeb;
@property (nonatomic, assign) UIViewController *parentController;

@end
