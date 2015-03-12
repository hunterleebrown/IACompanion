//
//  SearchViewController.h
//  IA
//
//  Created by Hunter on 7/23/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (void) searchBarSearchButtonClicked:(UISearchBar *)inSearchBar;


@end
