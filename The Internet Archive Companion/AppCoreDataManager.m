//
//  AppCoreDataManager.m
//  IA
//
//  Created by Hunter on 9/26/15.
//  Copyright © 2015 Hunter Lee Brown. All rights reserved.
//

#import "AppCoreDataManager.h"
#import "MediaUtils.h"


@interface AppCoreDataManager ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;


@end

@implementation AppCoreDataManager

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static AppCoreDataManager *appCoreDataManager;


+ (AppCoreDataManager *)sharedInstance
{
    if (!appCoreDataManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            appCoreDataManager = [[AppCoreDataManager alloc] init];
        });
        
    }
    
    return appCoreDataManager;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.fetchResultControllers = [NSMutableDictionary new];
        [self setupManagedObjectContext];
    }
    
    return self;
}

- (void)setupManagedObjectContext
{

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IA" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IA.sqlite"];
    
    NSError *error = nil;
    
    // handle db upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}



- (NSFetchedResultsController *)favoritesFetchedResultsController
{
    
    
    if (_favoritesFetchedResultsController != nil) {
        
        return _favoritesFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:[AppCoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[AppCoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
//    aFetchedResultsController.delegate = self;
    
    _favoritesFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_favoritesFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _favoritesFetchedResultsController;
}



- (NSFetchedResultsController *)fetchedResultsControllerForSchema:(NSString *)schema
                                                        cacheName:(NSString *)cacheName
                                                         delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:schema inManagedObjectContext:[AppCoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[AppCoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:cacheName];
    aFetchedResultsController.delegate = delegate;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [self.fetchResultControllers setObject:aFetchedResultsController forKey:schema];
    
    return aFetchedResultsController;
}


- (BOOL)hasFavoritesIdentifier:(NSString *)identifier
{
    NSFetchedResultsController *results = [self.fetchResultControllers objectForKey:@"Favorite"];
    NSArray *favorites = [results fetchedObjects];

    NSIndexSet *indexes = [favorites indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [((Favorite *)obj).identifier isEqualToString:identifier];
    }];
    
    return indexes.count > 0;
}

- (Favorite *)favoriteWithIdentifier:(NSString *)identifier
{
    NSFetchedResultsController *results = [self.fetchResultControllers objectForKey:@"Favorite"];
    NSArray *favorites = [results fetchedObjects];
    
    Favorite __block *foundFavorite;
    NSIndexSet *indexes = [favorites indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([((Favorite *)obj).identifier isEqualToString:identifier])
        {
            foundFavorite = (Favorite *)obj;
            return YES;
        }
        
        return NO;
    }];
    
    return foundFavorite;
}


- (void) addFavorite:(ArchiveSearchDoc *)doc{
    
    NSFetchedResultsController *results = [self.fetchResultControllers objectForKey:@"Favorite"];
    results.delegate = nil;
    
    NSManagedObjectContext *context = [results managedObjectContext];
    NSEntityDescription *entity = [[results fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    
    [newManagedObject setValue:doc.title forKey:@"title"];
    [newManagedObject setValue:doc.identifier forKey:@"identifier"];
    [newManagedObject setValue:@"URL" forKey:@"url"];
    [newManagedObject setValue:doc.title forKey:@"identifierTitle"];
    [newManagedObject setValue:[MediaUtils stringFromMediaType:doc.type] forKey:@"format"]; // bit of a hack.. storying mediatype on format. Could be confusing.
    [newManagedObject setValue:[NSNumber numberWithInteger:[[results fetchedObjects]count] + 1] forKey:@"displayOrder"];
    
    // Save the context.
    
    NSError *error = nil;
    
    if (![context save:&error])
        
    {
        
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         */
        
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        
    }
}


@end
