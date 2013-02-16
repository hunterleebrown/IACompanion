//
//  HomeNavTableView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"
#import "ArchiveSearchDoc.h"

@protocol HomeNavTouchDelegate <NSObject>

- (void) didTouchNavigationCellWithDoc:(ArchiveSearchDoc *)doc;

@end

@interface HomeNavTableView : UITableView <UITableViewDataSource, UITableViewDelegate, ArchiveDataServiceDelegate>

@property (weak, nonatomic) IBOutlet id<HomeNavTouchDelegate> touchDelegate;
@property (strong, nonatomic) ArchiveDataService  *audioService;
@property (strong, nonatomic) ArchiveDataService  *movieService;
@property (strong, nonatomic) ArchiveDataService  *textService;

@end
