//
//  ArchiveImageViewController.h
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ArchiveImageViewController : UIViewController<UIScrollViewDelegate>



@property (weak, nonatomic) IBOutlet UIButton *sharePhotoButton;
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet AsyncImageView *imageView;
@property (strong, nonatomic) NSString *archvieTitle;
@property (strong, nonatomic) NSString *archiveIdentifier;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)dismiss:(id)sender;

@end
