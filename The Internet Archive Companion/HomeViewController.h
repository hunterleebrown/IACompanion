//
//  ViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveCollectionView.h"


@interface HomeViewController : UIViewController {


}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet ArchiveCollectionView *audioCollection;
@property (nonatomic, retain) IBOutlet ArchiveCollectionView *videoCollection;
@property (nonatomic, retain) IBOutlet ArchiveCollectionView *textCollection;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;


@end