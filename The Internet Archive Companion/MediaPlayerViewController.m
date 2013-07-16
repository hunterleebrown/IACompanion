//
//  MeidaPlayerViewController.m
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ArchiveImageView.h"
#import "ArchiveFile.h"
#import "PlayerFile.h"
#import "PlayerTableViewCell.h"

@interface MediaPlayerViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet ArchiveImageView *imageView;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, retain) IBOutlet UITableView *playerTableView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIView *playerHolder;

@end

@implementation MediaPlayerViewController
@synthesize managedObjectContext, player, imageView, playButton, playerHolder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // using the device audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) {    }
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) {  }
    
    player = [[MPMoviePlayerController alloc] init];
    [player setControlStyle:MPMovieControlStyleNone];
    [player.view setBackgroundColor:[UIColor clearColor]];
    [playerHolder addSubview:player.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFileAndPlayNotification:) name:@"AddToPlayerListFileAndPlayNotification" object:nil];

    
}

- (void) viewDidAppear:(BOOL)animated{
    player.view.frame = CGRectMake(0, 0, playerHolder.frame.size.width, playerHolder.frame.size.height);


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePlayer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMediaPlayer" object:nil];
}


#pragma mark - Remote Control Events

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //[self doPlayPause:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
               // [self playPrevious];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
               // [self playNext];
                break;
                
            default:
                break;
        }
    }
    
}


- (void)startListWithFile:(PlayerFile *)file{
    if([[self.fetchedResultsController fetchedObjects] count] > 0){
        
        
        

           
            /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playlistFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackStateChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenToggleNotification:) name:MPMoviePlayerDidEnterFullscreenNotification object:player];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenToggleNotification:) name:MPMoviePlayerDidExitFullscreenNotification object:player];
            */
            

            [player stop];
            [player setContentURL:[NSURL URLWithString:file.url]];
            [player prepareToPlay];
            [player play];
            [self setSelectedCellOfPlayingFileForPlayer:player];

        
      
    }
    
}


#pragma mark - data and files
/* ##############################   DATA */

- (void) addToPlayerListFileAndPlayNotification:(NSNotification *)notification{
    [self addToPlayerListFileNotification:notification];
    PlayerFile *file = [[self.fetchedResultsController fetchedObjects] lastObject];
    [self startListWithFile:file];
    
}

- (void) addToPlayerListFileNotification:(NSNotification *)notification{
    ArchiveFile *file = notification.object;
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    // If appropriate, configure the new managed object.
    
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    
    [newManagedObject setValue:file.title forKey:@"title"];
    [newManagedObject setValue:file.identifier forKey:@"identifier"];
    [newManagedObject setValue:file.url forKey:@"url"];
    [newManagedObject setValue:file.identifierTitle forKey:@"identifierTitle"];
    [newManagedObject setValue:[file.file objectForKey:@"format"] forKey:@"format"];
    [newManagedObject setValue:[NSNumber numberWithInt:[[self.fetchedResultsController fetchedObjects]count] + 1] forKey:@"displayOrder"];
    
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


- (int) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}

- (void)configureCell:(PlayerTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PlayerFile *file = (PlayerFile *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.fileTitle.text = file.title;
    cell.identifierLabel.text = file.identifierTitle;
   // cell.fileFormat.text = file.format;
    cell.showsReorderControl = YES;
    [cell setFile:file];
    
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
 //   [_numberOfFiles setTitle:[NSString stringWithFormat:@"%i file%@", [sectionInfo numberOfObjects], [sectionInfo numberOfObjects] == 1 ? @"": @"s"]];
    
    return [sectionInfo numberOfObjects];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}


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
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //  NSLog(@"->      sourceIndexPath.row: %i", sourceIndexPath.row);
    // NSLog(@"-> destinationIndexPath.row: %i", destinationIndexPath.row);
    
    
    // Get a handle to the playlist we're moving
    NSMutableArray *sortedFiles = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
    
    // Get a handle to the call we're moving
    PlayerFile *playerFileWeAreMoving = [sortedFiles objectAtIndex:sourceIndexPath.row];
    
    // Remove the call from it's current position
    [sortedFiles removeObjectAtIndex:sourceIndexPath.row];
    
    // Insert it at it's new position
    [sortedFiles insertObject:playerFileWeAreMoving atIndex:destinationIndexPath.row];
    
    // Update the order of them all according to their index in the mutable array
    [sortedFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PlayerFile *zePlayerFile = (PlayerFile *)obj;
        zePlayerFile.displayOrder = [NSNumber numberWithInt:idx];
    }];
    
    
    
    
    
    
    
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(player){
        [player stop];
    }
    PlayerFile *file = ((PlayerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).file;
    //NSLog(@"-----> file.url: %@", file.url);
    
    
    [self startListWithFile:file];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlayerFile" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    // [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_playerTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_playerTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_playerTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = _playerTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(PlayerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    [_playerTableView endUpdates];
    [_playerTableView reloadData];
}


- (BOOL) shouldAutorotate{
    return YES;
}

- (int) indexOfInFileFromUrl:(NSURL *)url{
    
    NSArray *loadedFiles = [self.fetchedResultsController fetchedObjects];
    for(PlayerFile *file in loadedFiles){
        if([file.url isEqualToString:url.absoluteString]){
            return [loadedFiles indexOfObject:file];
        }
        
    }
    return -1;
}


- (void) setSelectedCellOfPlayingFileForPlayer:(MPMoviePlayerController *)thePlayer{
    if ([[self.fetchedResultsController fetchedObjects] count]> 0) {
        int index = [self indexOfInFileFromUrl:thePlayer.contentURL];
        //NSLog(@"--------> playing index: %i", index);
        
        if([_playerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]]){
            [_playerTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            
        }
        
        //        PlayerFile *file = [self.fetchedResultsController objectAtIndex:index];
        
        
        PlayerFile *file = (PlayerFile *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        //[imageView.archiveImage setUrlPath:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", file.identifier]];
       // [imageView.archiveImage startDownloading];
        
        //[_instructions setHidden:YES];
        
        [playButton setImage:[UIImage imageNamed:@"pause-button.png"] forState:UIControlStateNormal];

        
        
    }
    
}


#pragma mark - controls

- (IBAction)doPlayPause:(id)sender{
    
    
    if(player.playbackState == MPMoviePlaybackStatePlaying){
        
        [player pause];
        [playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
        
        
    } else if(player.playbackState == MPMoviePlaybackStatePaused){
        
        [player play];
        [playButton setImage:[UIImage imageNamed:@"pause-button.png"] forState:UIControlStateNormal];

        
    } else if(player.playbackState == MPMoviePlaybackStateSeekingBackward || player.playbackState == MPMoviePlaybackStateSeekingForward){
        [player endSeeking];
        [player pause];
        [playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];

        
    } else if(player.playbackState == MPMoviePlaybackStateStopped){
        
        [player play];
        [playButton setImage:[UIImage imageNamed:@"pause-button.png"] forState:UIControlStateNormal];
        
        
    }
    
    
}

- (IBAction)doNext:(id)sender{
    [self playNext];
}


- (IBAction)doPrevious:(id)sender{
    [self playPrevious];
    
}

- (IBAction)doForwards:(id)sender{
    if((player && player.playbackState == MPMoviePlaybackStatePlaying) || (player && player.playbackState == MPMoviePlaybackStateSeekingBackward)){
        [player beginSeekingForward];
        
    } else if(player && player.playbackState == MPMoviePlaybackStateSeekingForward){
        [player endSeeking];
    }
    
}

- (IBAction)doBackwards:(id)sender{
    if((player && player.playbackState == MPMoviePlaybackStatePlaying) || (player && player.playbackState == MPMoviePlaybackStateSeekingForward)){
        [player beginSeekingBackward];
        
    } else if(player && player.playbackState == MPMoviePlaybackStateSeekingBackward){
        [player endSeeking];
    }
    
}


- (void) playNext{
    int index = [self indexOfInFileFromUrl:player.contentURL];
    if(index >= 0) {
        int newIndex = index +1;
        if(newIndex == [[self.fetchedResultsController fetchedObjects ]count]){
            // Remove this class from the observers
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                                          object:player];
        } else {
            PlayerFile *newFile = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0]];
            [player setContentURL:[NSURL URLWithString:newFile.url]];
            [player stop];
            [player play];
            
            [self setSelectedCellOfPlayingFileForPlayer:player];
          //  [self monitorPlaybackTime];
            
        }
        
    } else {
        /*don't think this will ever happen */
        return;
    }
}

- (void) playPrevious {
    int index = [self indexOfInFileFromUrl:player.contentURL];
    if(index > 0) {
        int newIndex = index - 1;
        PlayerFile *newFile = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0]];
        [player setContentURL:[NSURL URLWithString:newFile.url]];
        [player stop];
        [player play];
        
        [self setSelectedCellOfPlayingFileForPlayer:player];
       // [self monitorPlaybackTime];
        
        
    } else {
        return;
    }
    
    
}

@end
