//
//  ArchiveMetadataTableView.h
//  IA
//
//  Created by Hunter on 2/13/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveMetadataTableView : UITableView <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) NSMutableDictionary *metadata;
@end
