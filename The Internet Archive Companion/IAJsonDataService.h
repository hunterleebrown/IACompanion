//
//  IAJsonService.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IADataService.h"

typedef enum {
    IADataServiceSortTypeDateDescending = 0,
    IADataServiceDownloadCount = 1,
    IADataServiceTitleAscending = 2
} IADataServiceSortType;


@interface IAJsonDataService : IADataService
@property (nonatomic, strong) NSMutableDictionary *rawResults;


- (id) initForAllItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type;
- (id) initForAllCollectionItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type;

- (id) initForMetadataDocsWithIdentifier:(NSString *)ident;
- (id) initStaffPicksDocsWithCollectionIdentifier:(NSString *)idString;
- (void) changeSortType:(IADataServiceSortType *)type;
- (void) setLoadMoreStart:(NSString *)lMS;

@end
