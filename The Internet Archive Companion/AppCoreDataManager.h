//
//  AppCoreDataManager.h
//  IA
//
//  Created by Hunter on 9/26/15.
//  Copyright © 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"
#import "Favorite.h"


@interface AppCoreDataManager : UIPopoverBackgroundView

+ (AppCoreDataManager *)sharedInstance;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *favoritesFetchedResultsController;
@property (nonatomic, strong) NSMutableDictionary *fetchResultControllers;


- (NSFetchedResultsController *)fetchedResultsControllerForSchema:(NSString *)schema cacheName:(NSString *)cacheName delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

- (BOOL)hasFavoritesIdentifier:(NSString *)identifier;
- (void)addFavorite:(ArchiveSearchDoc *)doc;

- (Favorite *)favoriteWithIdentifier:(NSString *)identifier;

@end
