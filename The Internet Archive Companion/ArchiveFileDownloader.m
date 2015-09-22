//
//  ArchiveFileDownloader.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveFileDownloader.h"

@interface ArchiveFileDownloader ()

@property (nonatomic, assign) BOOL isDownloading;

@end

@implementation ArchiveFileDownloader

@synthesize delegate;
@synthesize download;
@synthesize target;
@synthesize didFailSelector;
@synthesize didFinishSelector;
@synthesize downloadStatus;
@synthesize useCurrentRunLoop;


// Private
@synthesize isDownloading;



- (id)init {
    if ((self = [super init])) {
        download = [ArchiveFileDownload new];
        download.urlPath = @"";
        self.downloadStatus = ArchiveFileDownloaderDowloadStatusNotStarted;
    }
    return self;
}

- (id)initWithDelegate:(id) c {
    self = [self init];
    self.delegate = c;
    return self;
}

+ (ArchiveFileDownloader *)downloaderWithUrlPath:(NSString *)path {
    ArchiveFileDownloader *d = [[self alloc] init];
    d.download.urlPath = path;
    return d;
}


- (void)cancelActiveDownload {
    
    if (download != nil) {
        [download.connection cancel];
    }
    NSString *urlPath = download.urlPath;
    
    download = [ArchiveFileDownload new];
    download.urlPath = urlPath;
    
    self.downloadStatus = ArchiveFileDownloaderDowloadStatusCancelled;
}

- (void)retrieveCurrentDownloadFromWeb {
    if (isDownloading) {
        [self cancelActiveDownload];
        isDownloading = NO;
    }
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[download.urlPath stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLConnection *conn;
    
    if (useCurrentRunLoop) {
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [conn start];
    }
    else {
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    isDownloading = YES;
    self.downloadStatus = ArchiveFileDownloaderDowloadStatusInProgress;
    
	download.activeDownload = [NSMutableData data];
	download.active = YES;
	download.complete = NO;
	download.connection = conn;
	
}

- (void)retrieveCurrentDownloadFromCache {
    
	download.data = [[ArchiveCache sharedInstance].cache objectForKey:download.urlPath];
    if(download.data == nil) {
        NSLog(@"retrieveCurrentDownloadFromCache: No cached data found, downloading from web");
        
        [self retrieveCurrentDownloadFromWeb];
        return;
    }
    
    NSLog(@"retrieveCurrentDownloadFromCache: FOUND in cache");
    
    self.downloadStatus = ArchiveFileDownloaderDowloadStatusRetrievingFromCache;
    download.complete = YES;
    
    [self notifyDelegatesWithSuccess];
    
    download.activeDownload = nil;
    download.connection = nil;
}

- (void)notifyDelegatesWithSuccess {
    self.downloadStatus = ArchiveFileDownloaderDowloadStatusComplete;
    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishFileDownload:)]) {
       // NSLog(@"notifyDelegatesWithSuccess: delegate callback");
        [delegate didFinishFileDownload:download];
	}
    if (target != nil) {
        if (didFinishSelector != nil) {
            IMP imp = [target methodForSelector:didFinishSelector];
            void (*func)(id, SEL) = (void *)imp;
            func(target, didFinishSelector);
        }
    }
}

- (void)startDownloading {
        NSLog(@"started downloading %@", download.urlPath);
    if ([[ArchiveCache sharedInstance].cache objectForKey:download.urlPath]) {
        NSLog(@"startDownloading: from cache");
        [self retrieveCurrentDownloadFromCache];
    }
    else {
      //  NSLog(@"startDownloading: from web");
        [self retrieveCurrentDownloadFromWeb];
    }
}

- (void)startForcedDownloading {
   // NSLog(@"startForcedDownloading");
    [self retrieveCurrentDownloadFromWeb];
}




- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [download.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", [NSString stringWithFormat:@"connection:didFailWithError:. URL: '%@' failed with error: %@", download.urlPath, error]);
	// Clear the activeDownload property to allow later attempts
    // Release the connection now that it's finished
    isDownloading = NO;
    
    NSString *urlPath = download.urlPath;
    download.connection = nil;
    
    download = [ArchiveFileDownload new];
    download.urlPath = urlPath;
    
    self.downloadStatus = ArchiveFileDownloaderDowloadStatusFailed;
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:[NSString stringWithFormat:@"Download failed. \n %@", error.localizedDescription]];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(didFailFileDownload:)]) {
        [delegate didFailFileDownload:download];
	}
    if (target != nil) {
        if (didFailSelector != nil) {
            if([target respondsToSelector:didFailSelector]) {
//                [target performSelector:didFailSelector withObject:download];

                IMP imp = [target methodForSelector:didFailSelector];
                void (*func)(id, SEL, ArchiveFileDownload*) = (void *)imp;
                func(target, didFailSelector, download);
            }
        }
    }
    if (delegate != nil) {
		if (didFailSelector != nil) {
            if([delegate respondsToSelector:didFailSelector]) {
                [delegate performSelector:didFailSelector withObject:download];
            }
        }
        else if ([delegate respondsToSelector:@selector(didFailFileDownload:)]) {
            [delegate didFailFileDownload:download];
        }
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   // NSLog(@"connectionDidFinishLoading");
    
	download.data = [NSData dataWithData:download.activeDownload];
    
    [self notifyDelegatesWithSuccess];
    
    download.activeDownload = nil;
    download.connection = nil;
    isDownloading = NO;
    if(download.data)
    {
        [[ArchiveCache sharedInstance].cache setObject:download.data forKey:download.urlPath];
    }
}




@end
