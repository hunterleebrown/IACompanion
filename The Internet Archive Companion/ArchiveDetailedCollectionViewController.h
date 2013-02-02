//
//  ArchiveDetailCollectionViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"
#import "ArchiveDetailedCollectionViewCell.h"

@interface ArchiveDetailedCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIWebViewDelegate, ArchiveDataServiceDelegate> {

    NSMutableArray *docs;
    ArchiveDataService *dataService;
    NSString *archiveIdentifier;
    MediaType mediaType;
    
    
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UILabel *countingLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *loadMoreButton;

- (void)setCollectionIdentifier:(NSString *)identifier forType:(MediaType)type;
- (IBAction)loadMoreItems:(id)sender;

@end
