//
//  SearchView.h
//  IA
//
//  Created by Hunter Brown on 7/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView
@property (nonatomic, weak) IBOutlet UISegmentedControl *searchFilters;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@end
