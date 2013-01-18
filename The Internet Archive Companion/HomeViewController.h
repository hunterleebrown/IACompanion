//
//  ViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UIPopoverControllerDelegate> {

    UIPopoverController *homeNavPopoverController;
    id saveEditSender;
    id saveEditTarget;
    SEL saveEditAction;
    

}





@end