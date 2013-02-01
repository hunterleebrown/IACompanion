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

    NSArray *docs;
    ArchiveDataService *dataService;
    NSString *archiveIdentifier;
    IBOutlet UICollectionView *collectionView;
    
    
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

- (void)setCollectionIdentifier:(NSString *)identifier forType:(MediaType)type;


@end
