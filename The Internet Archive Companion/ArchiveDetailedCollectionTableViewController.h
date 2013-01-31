//
//  ArchiveDetailedCollectionTableViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"

@interface ArchiveDetailedCollectionTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ArchiveDataServiceDelegate> {

    ArchiveDataService *dataService;
    NSArray *docs;
    NSString *archiveIdentifier;

}



- (void) setCollectionIdentifier:(NSString *)identifier;

@end
