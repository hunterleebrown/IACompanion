//
//  ArchiveBookPageViewController.h
//  IA
//
//  Created by Hunter on 3/1/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveBookPageViewController : UIViewController


@property (nonatomic) int index;

@property (nonatomic, retain) IBOutlet UIImageView *leftShadow;
@property (nonatomic, retain) IBOutlet UIImageView *rightShadow;

@property (nonatomic, weak) IBOutlet UIButton *popButton;
- (IBAction)popMe:(id)sender;


@end
