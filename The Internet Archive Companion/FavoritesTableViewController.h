//
//  FavoritesTableViewController.h
//  IA
//
//  Created by Hunter on 10/5/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"
@interface FavoritesTableViewController : UITableViewController



- (void) addFavorite:(ArchiveSearchDoc *)doc;
- (void) removeFavorite:(ArchiveSearchDoc *)doc;

@end
