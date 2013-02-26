//
//  HomeContentTableView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveDataService.h"


@protocol HomeContentScrollingDelegate <NSObject>

- (void) didScroll;

@end

@interface HomeContentTableView : UITableView <UITableViewDataSource, UITableViewDelegate, ArchiveDataServiceDelegate> 


@property (nonatomic, retain) ArchiveDataService *service;
@property (weak, nonatomic) IBOutlet id<HomeContentScrollingDelegate> scrollDelegate;
@property (nonatomic) BOOL didTriggerLoadMore;
@property (nonatomic, weak) IBOutlet UILabel *totalFound;



@end
