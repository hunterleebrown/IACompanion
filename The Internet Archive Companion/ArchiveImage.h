//
//  ArchiveImage.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveImage : NSObject


- (id)initWithUrlPath:(NSString *)path;
- (void)startDownloading;
- (void)readFromCache;

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, getter = downloaded) BOOL downloaded;
@property BOOL lazy;


@end
