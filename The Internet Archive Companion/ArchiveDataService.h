//
//  ArchiveDataService.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveFile.h"

@protocol ArchiveDataServiceDelegate <NSObject>

@optional
- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results;
- (void) dataDidFinishLoadingWithRangeRequestResults:(NSString *)results;
- (void) dataDidFinishLoadingWithArchiveFile:(ArchiveFile *)file;


@end


typedef enum {
    MediaTypeNone = 0,
    MediaTypeAudio = 1,
    MediaTypeVideo = 2,
    MediaTypeTexts = 3,
    MediaTypeImage = 4,
    MediaTypeCollection = 5,
    MediaTypeAny = 6

}MediaType;

@interface ArchiveDataService : NSObject<NSURLConnectionDelegate> {

    NSDictionary *results;
    NSString *inUrl;
    NSCache *cache;
    id<ArchiveDataServiceDelegate> delegate;
    NSString *testUrl;
    NSString *loadMoreStart;
    NSOperationQueue *queue;

}
@property (nonatomic, retain) id<ArchiveDataServiceDelegate> delegate;

- (void) setAndLoadDataFromJSONUrl:(NSString *)url;
- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier;
- (void) getCollectionsWithIdentifier:(NSString *)identifier;
- (void) getDocsWithQueryString:(NSString *)query;
- (void) getDocsWithQueryString:(NSString *)query forMediaType:(MediaType)type;
- (void) loadMoreWithStart:(NSString *)loadMoreStart;
- (void) getDocsWithCollectionIdentifier:(NSString *)identifier;
- (void) doRangeRequestFromRange:(unsigned int)fromByte toRange:(unsigned int)toByte fromUrl:(NSString *)url;

- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier withSort:(NSString *)sort;
- (void) getStaffPicksDocsWithCollectionIdentifier:(NSString *)identifier;


- (void) getMetadataDocsWithIdentifier:(NSString *)identifier;
- (void) getMetadataFileWithName:(NSString *)fileName withIdentifier:(NSString *)identifier;

@end
