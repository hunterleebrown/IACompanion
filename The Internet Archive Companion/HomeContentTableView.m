//
//  HomeContentTableView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeContentTableView.h"
#import "ArchiveSearchDoc.h"

@implementation HomeContentTableView


- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self){
        [self setBackgroundColor:[UIColor orangeColor]];
        [self setDelegate:self];
        [self setDataSource:self];
        docs = [NSMutableArray new];

        service = [ArchiveDataService new];
        [service setDelegate:self];
        
    }
    return  self;

}


- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setBackgroundColor:[UIColor orangeColor]];
        [self setDelegate:self];
        [self setDataSource:self];
        docs = [NSMutableArray new];
        
        service = [ArchiveDataService new];
        [service setDelegate:self];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentTableViewCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentTableViewCell"];
    }
    
    
    
    ArchiveSearchDoc *doc = [docs objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:doc.title];

    return cell;
}



- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    
    [docs addObjectsFromArray:[results objectForKey:@"documents"]];
    [self reloadData];

}

- (void) getCollection:(NSString *)collectionIdentifier{

    [service getCollectionsWithIdentifier:collectionIdentifier];

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
