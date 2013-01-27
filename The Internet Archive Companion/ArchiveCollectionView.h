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
    NSArray *docs;

}

- (void) getCollectionWithName:(NSString *)name;

@end
