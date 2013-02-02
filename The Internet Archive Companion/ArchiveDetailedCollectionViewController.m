//
//  ArchiveDetailCollectionViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDetailedCollectionViewController.h"
#import "ArchiveSearchDoc.h"
#import "ArchiveDetailedViewController.h"

@interface ArchiveDetailedCollectionViewController () {
    int start;
    NSString *sort;
    BOOL loading;
}
@end

@implementation ArchiveDetailedCollectionViewController




- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        dataService = [ArchiveDataService new];
        [dataService setDelegate:self];
        docs = [NSMutableArray new];
        start = 0;
        sort = @"publicdate+asc";
        loading = NO;
    }
    return self;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    
}

- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    //docs = [results objectForKey:@"documents"];
    [docs addObjectsFromArray:[results objectForKey:@"documents"]];
    [self.collectionView reloadData];
    [_countingLabel setText:[NSString stringWithFormat:@"%i of %@", docs.count, [results objectForKey:@"numFound"]]];

    self.loadMoreButton.enabled = YES;
    
    
    loading = NO;
}



- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(loading){
        [self loadMoreItems:nil];
    }

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{

   // NSLog(@" offset: %f  width: %f ", scrollView.contentOffset.x + scrollView.frame.size.width, scrollView.contentSize.width);

    if(scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width + 250 && !loading){
        loading = YES;
    }
    
    
}


- (void)setCollectionIdentifier:(NSString *)identifier forType:(MediaType)type{
    archiveIdentifier = identifier;
    mediaType = type;

    [dataService getDocsWithType:mediaType withName:archiveIdentifier];

    
}


- (IBAction)loadMoreItems:(id)sender {
    start = start + docs.count;
    [dataService getDocsWithType:mediaType withName:archiveIdentifier withSort:sort withStart:[NSString stringWithFormat:@"%i", start]];
    self.loadMoreButton.enabled = NO;

}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return docs.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString *CellIdentifier = @"detailedCollectionCell";
    
    ArchiveDetailedCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    [cell.detailsView setDelegate:self];
    
    ArchiveSearchDoc *doc = [docs objectAtIndex:indexPath.row];
    NSString *tit = doc.title;
    
    [cell.title setText:tit];
    [cell.archiveImageView setAndLoadImageFromUrl:doc.headerImageUrl];
    
    NSString *html = [NSString stringWithFormat:@"<html><body style='font-size:14px; font-family:sans-serif'>%@</body></html>", doc.description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [cell.detailsView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                      MIMEType:@"text/html"
              textEncodingName:@"UTF-8"
                       baseURL:theBaseURL];
    
    
    if(indexPath.row == start){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:start inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"documentDetailModal"])
    {
        
        ArchiveDetailedViewController *detailViewController = [segue destinationViewController];
        [detailViewController setTitle:@"hi"];
        
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
