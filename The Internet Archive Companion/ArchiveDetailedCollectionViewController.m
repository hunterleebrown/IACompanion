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

- (NSString *)displayDateFromArchiveDateString:(NSString *)archiveInDate;

@end

@implementation ArchiveDetailedCollectionViewController

NSString *const DisplayDateFormat = @"MMMM d, YYYY";
//2002-07-16T00:00:00Z
NSString *const ArchiveDateFormat = @"yyyy'-'MM'-'dd'T'HH:mm:ss'Z'";


- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        dataService = [ArchiveDataService new];
        [dataService setDelegate:self];
        docs = [NSMutableArray new];
        start = 0;
        sort = @"publicdate+desc";
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

    
    
    loading = NO;
}



- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(loading){
        [self loadMoreItems:nil];
    }

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{

   // NSLog(@" offset: %f  width: %f ", scrollView.contentOffset.x + scrollView.frame.size.width, scrollView.contentSize.width);

    if(scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width + 100 && !loading){
        loading = YES;
    }
    
    
}


- (void)setCollectionIdentifier:(NSString *)identifier forType:(MediaType)type{
    archiveIdentifier = identifier;
    mediaType = type;

    [dataService getDocsWithType:mediaType withIdentifier:archiveIdentifier];

    
}


- (IBAction)loadMoreItems:(id)sender {
    start = start + docs.count;
    [dataService getDocsWithType:mediaType withIdentifier:archiveIdentifier withSort:sort withStart:[NSString stringWithFormat:@"%i", start]];

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
    
    if(doc.date){
        [cell.date setText:[self displayDateFromArchiveDateString:doc.date]];
        [cell.from setHidden:NO];
        [cell.date setHidden:NO];
    } else {
        [cell.from setHidden:YES];
        [cell.date setHidden:YES];
    }
    
    if(doc.publicDate){
        [cell.publicDate setText:[self displayDateFromArchiveDateString:doc.publicDate]];
        [cell.added setHidden:NO];
        [cell.publicDate setHidden:NO];
    } else {
        [cell.added setHidden:YES];
        [cell.publicDate setHidden:YES];
    }
    
    [cell.showButton setTag:indexPath.row];
    
    
    
    if([doc.rawDoc objectForKey:@"publisher"]){

        NSMutableString * pubs = [[NSMutableString alloc] init];
        for (NSObject * obj in [doc.rawDoc objectForKey:@"publisher"])
        {
            [pubs appendString:[obj description]];
        }
        
        [cell.publisher setText:pubs];
    }
    

    if([doc.rawDoc objectForKey:@"subject"]){
        
        NSMutableString * subs = [[NSMutableString alloc] init];
        for (NSObject * obj in [doc.rawDoc objectForKey:@"subject"])
        {
            if(![subs isEqualToString:@""]){
                [subs appendString:@", "];
            }
            [subs appendString:[obj description]];
        }
        
        [cell.subject setText:subs];
    }
    
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#fff; text-decoration:none;}</style></head><body style='background-color:#000; color:#fff; font-size:14px; font-family:sans-serif'>%@</body></html>", doc.description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [cell.detailsView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                      MIMEType:@"text/html"
              textEncodingName:@"UTF-8"
                       baseURL:theBaseURL];
    
    

    
    return cell;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"documentDetailModal"])
    {
        

        
    }

    
    if ([[segue identifier] isEqualToString:@"showDoc"])
    {
        UIButton *clickedButton = (UIButton *)sender;
        int indexFromSender = clickedButton.tag;
        
        ArchiveSearchDoc *doc = [docs objectAtIndex:indexFromSender];
        
        ArchiveDetailedViewController *detailViewController = [segue destinationViewController];
        [detailViewController setTitle:doc.title];
        [detailViewController setIdentifier:doc.identifier];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Utils
- (NSString *) displayDateFromArchiveDateString:(NSString *)archiveInDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = ArchiveDateFormat;
    NSDate *sDate = [dateFormatter dateFromString:archiveInDate];
    
    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:DisplayDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];
    
    return theDate;
}


#pragma marks - WebView 

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    return YES;

}

@end
