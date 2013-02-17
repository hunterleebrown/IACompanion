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
#import "ArchiveDetailedViewController.h"
#import "StringUtils.h"

@interface HomeContentTableView () {
    int start;
    NSString *sort;
    NSMutableArray *docs;
    int numFound;
}

@end

@implementation HomeContentTableView


- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self){
        [self setDelegate:self];
        [self setDataSource:self];
        docs = [NSMutableArray new];
        start = 0;
        sort = @"publicdate+desc";
        _didTriggerLoadMore = NO;
        numFound = 0;
        
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
        start = 0;
        sort = @"publicdate+desc";
        _didTriggerLoadMore = NO;
        numFound = 0;
        
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
    [cell setDoc:doc];
    
    
    if([doc.rawDoc objectForKey:@"subject"]){
        cell.subject.text = [StringUtils stringFromObject:[doc.rawDoc objectForKey:@"subject"]];
    }
    if([doc.rawDoc objectForKey:@"date"]){
        cell.date.text = [StringUtils stringFromObject:[doc.rawDoc objectForKey:@"date"]];

    }

    
    
    return cell;
}






- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{

    if(((NSArray *)[results objectForKey:@"documents"]).count > 0) {
        
        if(!_didTriggerLoadMore){
            [docs removeAllObjects];
        }
        
        
        [docs addObjectsFromArray:[results objectForKey:@"documents"]];
        
        [self reloadData];
        
        if(!_didTriggerLoadMore){
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:YES];
        }
        numFound = [[results objectForKey:@"numFound"] intValue];
        
        [_totalFound setText:[NSString stringWithFormat:@"%i items found",  numFound]];
        [_totalFound setTextColor:[UIColor blackColor]];

    } else {
        numFound = [[results objectForKey:@"numFound"] intValue];
        [_totalFound setText:[NSString stringWithFormat:@"%i items found",  numFound]];
        [_totalFound setTextColor:[UIColor whiteColor]];

    }
    
}






#pragma mark - scroll view delegates

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(_scrollDelegate && [_scrollDelegate respondsToSelector:@selector(didScroll)]){
        [_scrollDelegate didScroll];
    }

}



- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    // NSLog(@" offset: %f  width: %f ", scrollView.contentOffset.x + scrollView.frame.size.width, scrollView.contentSize.width);
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 300){
        if(docs.count > 0  && docs.count < numFound ){
            NSLog(@" docs.count:%i  numFound:%i", docs.count, numFound);
            [self loadMoreItems:nil];
        }
        
    }
    
    
}


- (void)loadMoreItems:(id)sender {
    NSLog(@"-----> trigger loadmore");
    _didTriggerLoadMore = YES;
    start = start + docs.count;
    [_service loadMoreWithStart:[NSString stringWithFormat:@"%i", start]];
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
