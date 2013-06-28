//
//  ArchiveMetadataTableView.m
//  IA
//
//  Created by Hunter on 2/13/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveMetadataTableView.h"
#import "ArchiveMetadataTableViewCell.h"
#import "StringUtils.h"

@interface ArchiveMetadataTableView () {

    NSArray *metakeys;
    NSArray *metavalues;
    
    NSMutableArray *useTheseKeys;
}

@end

@implementation ArchiveMetadataTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setDataSource:self];
        [self setDelegate:self];
        useTheseKeys = [NSMutableArray new];
        _metadata = [NSMutableDictionary new];
    }
    return self;
}


- (void) setMetadata:(NSMutableDictionary *)metadata {
    metakeys = [metadata allKeys];
    for(NSString *k in metakeys){
        [_metadata setObject:[metadata objectForKey:k] forKey:k];
    }
    [_metadata removeObjectForKey:@"identifier"];
    [_metadata removeObjectForKey:@"title"];
    [_metadata removeObjectForKey:@"description"];
    [_metadata removeObjectForKey:@"subject"];
    [_metadata removeObjectForKey:@"md5s"];

    
    
    [self reloadData];
    
}


- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _metadata.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ArchiveMetadataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArchiveMetadataTableViewCell"];
    
    
    cell.key.text = [[_metadata.allKeys objectAtIndex:indexPath.row] capitalizedString];
    cell.value.text = [StringUtils stringFromObject:[_metadata objectForKey:[_metadata.allKeys objectAtIndex:indexPath.row]]];
    
    
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
