//
//  FavoritesTableViewController.m
//  IA
//
//  Created by Hunter on 10/5/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "Favorite.h"
#import "FavoritesCell.h"
#import "FontMapping.h"
#import "MediaUtils.h"
#import "AppCoreDataManager.h"

@interface FavoritesTableViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FavoritesTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //Create a button
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:CLOSE style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
//    [closeButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:ICONOCHIVE size:25]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = closeButton;

    self.title = @"Your Favorites List";

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;

}



- (void) close{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    
    if(self.fetchedResultsController.sections.count > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    
    } else {
        
        return 0;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favCell";
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Favorite *fav = (Favorite *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.title setText:fav.title];

    MediaType mediatype = [MediaUtils mediaTypeFromString:fav.format];
    [cell.typeLabel setText:[MediaUtils iconStringFromMediaType:mediatype]];
    [cell.typeLabel setTextColor:[MediaUtils colorFromMediaType:mediatype]];

    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Favorite *fav = (Favorite *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    ArchiveSearchDoc *doc = [ArchiveSearchDoc new];
    [doc setIdentifier:fav.identifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void) addFavorite:(ArchiveSearchDoc *)doc{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

    
    [newManagedObject setValue:doc.title forKey:@"title"];
    [newManagedObject setValue:doc.identifier forKey:@"identifier"];
    [newManagedObject setValue:@"URL" forKey:@"url"];
    [newManagedObject setValue:doc.title forKey:@"identifierTitle"];
    [newManagedObject setValue:[MediaUtils stringFromMediaType:doc.type] forKey:@"format"]; // bit of a hack.. storying mediatype on format. Could be confusing.
    [newManagedObject setValue:[NSNumber numberWithInteger:[[self.fetchedResultsController fetchedObjects]count] + 1] forKey:@"displayOrder"];
    
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

- (void)removeFavorite:(ArchiveSearchDoc *)doc
{
    
    Favorite *fave = [[AppCoreDataManager sharedInstance] favoriteWithIdentifier:doc.identifier];
    
    NSLog(@"------------> fave:%@", fave);
    

    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:fave];
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }


    
    if([[AppCoreDataManager sharedInstance].fetchResultControllers objectForKey:@"Favorite"] != nil)
    {
        _fetchedResultsController = [[AppCoreDataManager sharedInstance].fetchResultControllers objectForKey:@"Favorite"];
        _fetchedResultsController.delegate = self;
    }
    else
    {
        _fetchedResultsController = [[AppCoreDataManager sharedInstance] fetchedResultsControllerForSchema:@"Favorite" cacheName:@"FavoritesRequest" delegate:self];
    }

    
    return _fetchedResultsController;
}







- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
}



#pragma Editing Rows


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
    }
    
    
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //  NSLog(@"->      sourceIndexPath.row: %i", sourceIndexPath.row);
    // NSLog(@"-> destinationIndexPath.row: %i", destinationIndexPath.row);
    
    
    // Get a handle to the playlist we're moving
    NSMutableArray *sortedFiles = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
    
    // Get a handle to the call we're moving
    Favorite *favorite = [sortedFiles objectAtIndex:sourceIndexPath.row];
    
    // Remove the call from it's current position
    [sortedFiles removeObjectAtIndex:sourceIndexPath.row];
    
    // Insert it at it's new position
    [sortedFiles insertObject:favorite atIndex:destinationIndexPath.row];
    
    // Update the order of them all according to their index in the mutable array
    [sortedFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Favorite *zeFavorite = (Favorite *)obj;
        zeFavorite.displayOrder = [NSNumber numberWithInteger:idx];
    }];
    
    
    
    
    
    
    
}




@end
