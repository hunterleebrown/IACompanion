//
//  ArchiveFileDownload.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveFileDownload : NSObject


@property (strong) NSMutableData *activeDownload;
@property (strong) NSURLConnection *connection;

@property (copy) NSString *urlPath;
@property (strong) NSData *data;
@property BOOL active;
@property BOOL complete;

@end
