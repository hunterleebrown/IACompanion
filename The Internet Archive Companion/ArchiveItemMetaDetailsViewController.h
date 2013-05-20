//
//  ArchiveItemMetaDetailsViewController.h
//  IA
//
//  Created by Hunter on 5/19/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveMetadataTableView.h"

@interface ArchiveItemMetaDetailsViewController : UIViewController


@property (nonatomic, weak) IBOutlet ArchiveMetadataTableView *metadataTableView;
@property (nonatomic, strong) NSDictionary *metaData;

@end
