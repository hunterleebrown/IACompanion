//
//  SearchView.h
//  IA
//
//  Created by Hunter Brown on 7/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UISegmentedControl *searchFilters;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *searchResultsTable;
@end
