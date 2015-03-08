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
    IADataServiceSortTypeDateDescending,
    IADataServiceSortTypeDateAscending,
    IADataServiceSortTypeDownloadDescending,
    IADataServiceSortTypeDownloadAscending,
    IADataServiceSortTypeTitleAscending,
    IADataServiceSortTypeTitleDescending,
    IADataServiceSortTypeNone


} IADataServiceSortType;


@interface IAJsonDataService : IADataService

@property (nonatomic, strong) NSMutableDictionary *rawResults;

- (id) initForAllItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type;
- (id) initForAllCollectionItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type;
- (id) initWithQueryString:(NSString *)query;
- (id) initWithAllPicks;


- (id) initForMetadataDocsWithIdentifier:(NSString *)ident;
- (void) changeToStaffPicks;
- (void) changeToSubCollections;
- (void) changeSortType:(IADataServiceSortType *)type;
- (void) setLoadMoreStart:(NSString *)lMS;

- (void) searchChangeSortType:(IADataServiceSortType *)type;


@end
