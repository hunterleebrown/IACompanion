//
//  ArchiveBookPageImageViewController.h
//  IA
//
//  Created by Hunter Brown on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ArchiveBookPageImageViewController : UIViewController



@property (nonatomic, retain) AsyncImageView *aSyncImageView;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *zipFile;
@property (nonatomic) int index;
@property (nonatomic, retain) NSString *url;

- (id) initWithServer:(NSString *)server withZipFileLocation:(NSString *)zipFile withFileName:(NSString *)name withIdentifier:(NSString *)identifier withIndex:(int)index;

@end
