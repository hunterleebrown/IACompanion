//
//  NewItemViewController.m
//  IA
//
//  Created by Hunter Brown on 3/27/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "NewItemViewController.h"
#import "IAJsonDataService.h"

@interface NewItemViewController () <IADataServiceDelegate>

@property (nonatomic, strong) IAJsonDataService *service;
@property (nonatomic, strong) ArchiveDetailDoc *detDoc;


@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.service forceFetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setSearchDoc:(ArchiveSearchDoc *)searchDoc{
    _searchDoc = searchDoc;
    self.service = nil;
    self.service = [[IAJsonDataService alloc] initForMetadataDocsWithIdentifier:_searchDoc.identifier];
    [self.service setDelegate:self];
    
}


#pragma mark - Results

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    //ArchiveDetailDoc *doc = ((IAJsonDataService *)service).rawResults
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    self.detDoc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    

}

@end
