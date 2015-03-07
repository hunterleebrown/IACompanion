//
//  CollectionDataHandler.h
//  IA
//
//  Created by Hunter on 7/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAJsonDataService.h"

@interface CollectionDataHandlerAndHeaderView : UIView  <UITableViewDataSource, UITableViewDelegate, IADataServiceDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) IBOutlet UITableView *collectionTableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *filters;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;


@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSString *identifier;

- (IBAction)segmentedControlIndexChanged:(id)sender;

@end

