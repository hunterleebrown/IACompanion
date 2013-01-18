//
//  HomeNavigationTableViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"

@interface HomeNavigationTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, ArchiveDataServiceDelegate> {


    ArchiveDataService *archiveDataService;
    NSArray *docs;
    
}

@end
