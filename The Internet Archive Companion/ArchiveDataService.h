//
//  ArchiveDataService.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArchiveDataServiceDelegate <NSObject>

- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results;

@end


typedef enum {
    MediaTypeNone = 0,
    MediaTypeAudio = 1,
    MediaTypeVideo = 2,
    MediaTypeTexts = 3,
    MediaTypeImage = 4,
    MediaTypeCollection = 5

}MediaType;

@interface ArchiveDataService : NSObject {

    NSDictionary *results;
    NSString *inUrl;
    NSCache *cache;
    id<ArchiveDataServiceDelegate> delegate;
    NSString *testUrl;
    NSString *loadMoreStart;

}
@property (nonatomic, retain) id<ArchiveDataServiceDelegate> delegate;

- (void) setAndLoadDataFromJSONUrl:(NSString *)url;
- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier;
- (void) getCollectionsWithIdentifier:(NSString *)identifier;
- (void) getDocsWithQueryString:(NSString *)query;
- (void) getDocsWithQueryString:(NSString *)query forMediaType:(MediaType)type;
- (void) loadMoreWithStart:(NSString *)loadMoreStart;
- (void) getDocsWithCollectionIdentifier:(NSString *)identifier;



- (void) getMetadataDocsWithIdentifier:(NSString *)identifier;


@end
