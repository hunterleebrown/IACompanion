//
//  ArchiveCollectionViewHelper.m
//  IA
//
//  Created by Hunter Brown on 7/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveCollectionViewControllerHelper.h"
#import "IAJsonDataService.h"
#import "ArchiveSearchDoc.h"

@interface ArchiveCollectionViewControllerHelper () <IADataServiceDelegate>
@property (nonatomic, strong) IAJsonDataService *service;

@end

@implementation ArchiveCollectionViewControllerHelper
@synthesize service;



- (void) setSearchDoc:(ArchiveSearchDoc *)searchDoc{
    _searchDoc = searchDoc;
    service = [[IAJsonDataService alloc] initForMetadataDocsWithIdentifier:_searchDoc.identifier];
    [service setDelegate:self];
    [service fetchData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
}

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];
    ArchiveDetailDoc *doc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
}

@end
