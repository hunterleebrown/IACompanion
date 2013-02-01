//
//  ArchiveDetailCollectionViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDetailedCollectionViewController.h"
#import "ArchiveSearchDoc.h"

@interface ArchiveDetailedCollectionViewController ()

@end

@implementation ArchiveDetailedCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    docs = [results objectForKey:@"documents"];
    [self.collectionView reloadData];
    
}

- (void)setCollectionIdentifier:(NSString *)identifier forType:(MediaType)type{
    archiveIdentifier = identifier;
    
    dataService = [ArchiveDataService new];
    [dataService setDelegate:self];
    [dataService getDocsWithType:type WithName:archiveIdentifier];

    
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
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [cell.detailsView loadData:[doc.description dataUsingEncoding:NSUTF8StringEncoding]
                      MIMEType:@"text/html"
              textEncodingName:@"UTF-8"
                       baseURL:theBaseURL];
    
    
    
    return cell;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
