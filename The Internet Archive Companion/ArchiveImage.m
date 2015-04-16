//
//  ArchiveImage.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveImage.h"
#import "ArchiveFileDownloader.h"


@interface ArchiveImage ()

@property (nonatomic, strong) ArchiveFileDownloader *downloader;
@property (nonatomic, assign) BOOL isDownloading;

@end

@implementation ArchiveImage

@synthesize downloader, downloaded, urlPath, lazy, contentImage, isDownloading;


- (id)init {
    self = [super init];
	if (self) {
        lazy = YES;
        downloader = [[ArchiveFileDownloader alloc] init];
        downloader.useCurrentRunLoop = YES;
	}
    
	return self;
}

- (id)initWithUrlPath:(NSString *)path {
	self = [self init];
	self.urlPath = path;
    [downloader addObserver:self forKeyPath:@"downloadStatus" options:NSKeyValueObservingOptionNew context:NULL];

	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    self.downloaded = YES;
    self.urlPath = [[aDecoder decodeObjectForKey:@"RIUrlPath"] copy];
    self.contentImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"RIContentImage"]];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:urlPath forKey:@"RIUrlPath"];
    [aCoder encodeObject:UIImagePNGRepresentation(contentImage) forKey:@"RIContentImage"];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"downloadStatus"]) {
        ArchiveFileDownloaderDowloadStatus status = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        if (status == ArchiveFileDownloaderDowloadStatusComplete) {
            isDownloading = NO;
            self.contentImage = [UIImage imageWithData:downloader.download.data];
            self.downloaded = YES;
            
        }
    }
}

- (void)readFromCache {
    self.downloaded = YES;
}

- (void)startDownloading {
    if (isDownloading) return;

    isDownloading = YES;
    [downloader startDownloading];
}

- (void)setUrlPath:(NSString *)value {
    if (urlPath != value) {
        urlPath = [value copy];
        if ([[ArchiveCache sharedInstance].cache objectForKey:urlPath]) {
            if (!lazy) {
                [self readFromCache];
            }
        }
        else {
            downloader.download.urlPath = urlPath;
            if (!lazy) {
                [self startDownloading];
            }
        }
    }
}

- (BOOL)downloaded {
    return self.contentImage != nil;
}


- (UIImage *)contentImage {
    if (contentImage == nil) {
        if (urlPath != nil && [[ArchiveCache sharedInstance].cache objectForKey:urlPath]) {
            
            
            return [UIImage imageWithData:[[ArchiveCache sharedInstance].cache objectForKey:urlPath]];
        }
        [self startDownloading];
        return nil;
    }
    return contentImage;
}

- (void) dealloc{    
    @try{
        [downloader removeObserver:self forKeyPath:@"downloadStatus"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

@end
