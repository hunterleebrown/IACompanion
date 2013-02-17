//
//  ArchiveShareViewController.h
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ArchiveShareViewController : UIViewController


@property (nonatomic, strong) UIPopoverController *myPopOverController;

@property (nonatomic, weak) IBOutlet UIButton *faceBookButton;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) NSString *archiveIdentifier;
@property (nonatomic, retain) NSString *archiveTitle;
- (IBAction)doShare:(id)sender;

@end
