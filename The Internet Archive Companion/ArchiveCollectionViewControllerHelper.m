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



- (void) setSearchDoc:(ArchiveSearchDoc *)searchDoc{
    _searchDoc = searchDoc;
    self.service = [[IAJsonDataService alloc] initForMetadataDocsWithIdentifier:self.searchDoc.identifier];
    [self.service setDelegate:self];
    [self.service forceFetchData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
}

- (void) dataDidBecomeAvailableForService:(IADataService *)inService{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];
    ArchiveDetailDoc *doc = [[((IAJsonDataService *)inService).rawResults objectForKey:@"documents"] objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
}

@end
