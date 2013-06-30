//
//  IADataService.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "IADataService.h"

@interface IADataService () 

@property (nonatomic, strong) ArchiveFileDownloader *downloader;
@end


@implementation IADataService
@synthesize urlStr, downloader, delegate;


- (id)init {
    self = [super init];
    if (self != nil) {
        delegate = nil;
        downloader = [[ArchiveFileDownloader alloc] init];
        downloader.delegate = self;
    }
    return self;
}

- (id) initWithUrlString:(NSString *)urlString{
    self = [self init];
    if(self){
        self.urlStr = urlString;
    }
    
    return self;
}

- (void) stopFetchingData{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [downloader cancelActiveDownload];
}
- (void) fetchData{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    downloader.download.urlPath = self.urlStr;
   
    
    NSLog(@" FETCH DATA BEGIN: %@", self.urlStr);
    [downloader startDownloading];
}

- (void) forceFetchData{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    downloader.download.urlPath = self.urlStr;
    NSLog(@" FORCE FETCH DATA BEGIN: %@", self.urlStr);
    [downloader startForcedDownloading];
}

- (void) didFinishFileDownload:(ArchiveFileDownload *)download{
    // Should be handled by delegate
}
        



@end
