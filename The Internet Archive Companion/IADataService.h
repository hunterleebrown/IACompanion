//
//  IADataService.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveFileDownloader.h"


@class IADataService;
@protocol IADataServiceDelegate <NSObject>

- (void)dataDidBecomeAvailableForService:(IADataService *)service;
@optional
- (void)dataDidFailToLoadForService:(IADataService *)service;

@end

@interface IADataService : NSObject<ArchiveFileDownloaderDelegate>

@property (nonatomic, assign) id<IADataServiceDelegate> delegate;
@property (nonatomic, strong) NSString *urlStr;

- (id)initWithUrlString:(NSString *)urlString;
- (void)fetchData;
- (void)forceFetchData;
- (void)stopFetchingData;

@end
