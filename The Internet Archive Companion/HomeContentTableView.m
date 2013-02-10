//
//  HomeContentTableView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeContentTableView.h"
#import "ArchiveSearchDoc.h"
#import "HomeContentCell.h"

@implementation HomeContentTableView


- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self){
        [self setDelegate:self];
        [self setDataSource:self];
        docs = [NSMutableArray new];

        _service = [ArchiveDataService new];
        [_service setDelegate:self];
        
    }
    return  self;

}


- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setDelegate:self];
        [self setDataSource:self];
        docs = [NSMutableArray new];
        
        _service = [ArchiveDataService new];
        [_service setDelegate:self];
    
    }
    return self;
}




- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return docs.count;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeContentCell"];
    ArchiveSearchDoc *doc = [docs objectAtIndex:indexPath.row];
    
    [cell.title setText:doc.title];
    [cell.aSyncImageView setAndLoadImageFromUrl:doc.headerImageUrl];
    return cell;
}



- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    [docs removeAllObjects];
    [docs addObjectsFromArray:[results objectForKey:@"documents"]];
    [self reloadData];

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
