//
//  ArchiveCollectionView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"

@interface ArchiveCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, ArchiveDataServiceDelegate> {

    ArchiveDataService *dataService;

}

- (void) getCollectionWithName:(NSString *)name;
@property (nonatomic, assign) NSArray *docs;

@end
