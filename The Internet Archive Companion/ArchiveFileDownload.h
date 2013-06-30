//
//  ArchiveFileDownload.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveFileDownload : NSObject


@property (retain) NSMutableData *activeDownload;
@property (retain) NSURLConnection *connection;

@property (copy) NSString *urlPath;
@property (retain) NSData *data;
@property BOOL active;
@property BOOL complete;

@end
