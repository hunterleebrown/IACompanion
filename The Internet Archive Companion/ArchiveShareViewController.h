//
//  ArchiveShareViewController.h
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>



@interface ArchiveShareViewController : UIViewController<MFMailComposeViewControllerDelegate>


@property (nonatomic, strong) UIPopoverController *myPopOverController;

@property (nonatomic, weak) IBOutlet UIButton *faceBookButton;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) NSString *archiveIdentifier;
@property (nonatomic, retain) NSString *archiveTitle;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* closeButton;

- (IBAction)pop:(id)sender;
- (IBAction)doShare:(id)sender;

@end
