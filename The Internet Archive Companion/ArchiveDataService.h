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
    MediaTypeCollection = 0,
    MediaTypeVideo = 1,
    MediaTypeAudio = 2,
    MediaTypeTexts = 3
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
- (void) loadMoreWithStart:(NSString *)loadMoreStart;

- (void) getMetadataDocsWithIdentifier:(NSString *)identifier;


@end
