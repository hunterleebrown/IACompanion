//
//  ItemContentViewController.h
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ContentViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ItemContentViewController : ContentViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>


@property (nonatomic, strong) ArchiveSearchDoc *searchDoc;

- (IBAction)addFavorite:(id)sender;

@end
