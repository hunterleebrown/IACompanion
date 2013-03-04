//
//  ArchivePhoneExtraDetailsViewController.h
//  IA
//
//  Created by Hunter Brown on 2/21/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveMetadataTableView.h"

@interface ArchivePhoneExtraDetailsViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *description;
@property (nonatomic, weak) IBOutlet ArchiveMetadataTableView *metadataTableView;
@property (nonatomic, retain) NSString *webContent;
@property (nonatomic, retain) NSDictionary *metadata;

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;


- (IBAction)close:(id)sender;
- (void) loadWebView:(NSString *)description;

@end
