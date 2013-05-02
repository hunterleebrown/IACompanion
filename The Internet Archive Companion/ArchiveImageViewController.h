//
//  ArchiveImageViewController.h
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ArchiveImageViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIBarButtonItem *sharePhoto;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet AsyncImageView *view;
@property (strong, nonatomic) NSString *archvieTitle;


- (IBAction)dismiss:(id)sender;

@end
