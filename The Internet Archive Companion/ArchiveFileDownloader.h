//
//  ArchiveFileDownloader.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveCache.h"
#import "ArchiveFileDownload.h"


typedef enum {
    ArchiveFileDownloaderDowloadStatusNotStarted           = 0,
    ArchiveFileDownloaderDowloadStatusInProgress           = 1,
    ArchiveFileDownloaderDowloadStatusRetrievingFromCache  = 2,
    ArchiveFileDownloaderDowloadStatusComplete             = 3,
    ArchiveFileDownloaderDowloadStatusFailed               = 4,
    ArchiveFileDownloaderDowloadStatusCancelled            = 5,
    
} ArchiveFileDownloaderDowloadStatus;


@protocol ArchiveFileDownloaderDelegate <NSObject>

- (void)didFinishFileDownload:(ArchiveFileDownload *)download;

@optional
- (void)didFailFileDownload:(ArchiveFileDownload *)download;

@end


@interface ArchiveFileDownloader : NSObject


@property (nonatomic, assign) id <ArchiveFileDownloaderDelegate> delegate;
@property (nonatomic, assign) id target;
@property (nonatomic, readonly) ArchiveFileDownload *download;
@property (nonatomic, assign) BOOL useCurrentRunLoop;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) SEL didFailSelector;
@property (nonatomic, assign) ArchiveFileDownloaderDowloadStatus downloadStatus;


- (id)initWithDelegate:(id) consumer;
+ (ArchiveFileDownloader *)downloaderWithUrlPath:(NSString *)path;

- (void)startDownloading;
- (void)startForcedDownloading;
- (void)cancelActiveDownload;



@end
