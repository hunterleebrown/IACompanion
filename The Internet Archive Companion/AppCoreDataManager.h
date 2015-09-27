//
//  AppCoreDataManager.h
//  IA
//
//  Created by Hunter on 9/26/15.
//  Copyright © 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCoreDataManager : UIPopoverBackgroundView

+ (AppCoreDataManager *)sharedInstance;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *favoritesFetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsControllerForSchema:(NSString *)schema cacheName:(NSString *)cacheName delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

@end
