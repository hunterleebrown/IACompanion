//
//  ArchivePlayerViewController.m
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchivePlayerViewController.h"
#import "ArchivePlayerTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ArchiveSearchDoc.h"
#import "PlayerFile.h"
#import "AppDelegate.h"
#import "StringUtils.h"




@interface ArchivePlayerViewController () {
    MPMoviePlayerController *player;
    BOOL tableIsEditing;
    ArchiveDataService *service;
    BOOL changingPlaylistOrder;
    BOOL sliderIsTouched;

}

@end

@implementation ArchivePlayerViewController
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFileNotification:) name:@"AddToPlayerListFileNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFileAndPlayNotification:) name:@"AddToPlayerListFileAndPlayNotification" object:nil];

        
        [_playerTableView setAllowsSelectionDuringEditing:NO];

  
       // using the device audio session
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *setCategoryError = nil;
        BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (!success) {    } 
        
        NSError *activationError = nil;
        success = [audioSession setActive:YES error:&activationError];
        if (!success) {  }
     
        
        tableIsEditing = NO;
        
        
        service = [ArchiveDataService new];
        [service setDelegate:self];
        

        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   // [_toolbar setBackgroundImage:[UIImage imageNamed:@"mediabar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    
    
    //[service getMetadataFileWithName:@"01Fanfare.mp3" withIdentifier:@"HunterLeeBrownWorkedBrass"];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
    }
    // Pass the managed object context to the view controller.
    managedObjectContext = context;

    self.slider.value = 0.0;
    sliderIsTouched = NO;

}

#pragma mark - Remote Control Events

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {

    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self doPlayPause:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self playPrevious];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self playNext];
                break;
                
            default:
                break;
        }
    }

}

- (void) dataDidFinishLoadingWithArchiveFile:(ArchiveFile *)file{

    
    [self addToPlayerListFile:file];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (int) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}

- (void)configureCell:(ArchivePlayerTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PlayerFile *file = (PlayerFile *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.fileTitle.text = file.title;
    cell.identifierLabel.text = file.identifierTitle;
    cell.fileFormat.text = file.format;
    cell.showsReorderControl = YES;
    [cell setFile:file];
    
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    [_numberOfFiles setTitle:[NSString stringWithFormat:@"%i file%@", [sectionInfo numberOfObjects], [sectionInfo numberOfObjects] == 1 ? @"": @"s"]];

    return [sectionInfo numberOfObjects];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ArchivePlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
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
    PlayerFile *file = ((ArchivePlayerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).file;
    //NSLog(@"-----> file.url: %@", file.url);
    
    
    [self startListWithFile:file];

}

- (IBAction)editList:(id)sender{
    tableIsEditing = !tableIsEditing;
    [_editListButton setTitle:tableIsEditing ? @"Done" : @"Edit"];
    [_playerTableView setEditing:tableIsEditing animated:YES];
    if(player){
        [self setSelectedCellOfPlayingFileForPlayer:player];
    }
    
    if(!tableIsEditing){
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        // Save the managed object context
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }

}

- (IBAction)clearList:(id)sender{
    //[playerFiles removeAllObjects];
    
    //[_playerTableView reloadData];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    for(PlayerFile *f in [self.fetchedResultsController fetchedObjects]){
        [context deleteObject:f];
    }
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    

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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
    [newManagedObject setValue:[NSNumber numberWithInt:[[self.fetchedResultsController fetchedObjects]count]] forKey:@"displayOrder"];
    
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
    
    
   // [self addToPlayerListFile:file];
    


}

- (void)addToPlayerListFile:(ArchiveFile *)file{
 //   [playerFiles addObject:file];
   // [_playerTableView reloadData];
}



- (IBAction)hidePlayer:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePlayerNotification" object:nil];

}

- (IBAction)togglePlayer:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayerNotification" object:nil];
    
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

        
        [_backgroundImage setAndLoadImageFromUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", file.identifier]];
       
        [_instructions setHidden:YES];
        

        

    }

}

- (void)startListWithFile:(PlayerFile *)file{
    if([[self.fetchedResultsController fetchedObjects] count] > 0){
        
        
        
        if(!player){
            player = [[MPMoviePlayerController alloc] init];
            [player setControlStyle:MPMovieControlStyleNone];
            [player.view setBackgroundColor:[UIColor clearColor]];
            [self.playerHolder addSubview: player.view];
            [player.view setFrame: self.playerHolder.bounds];  // player's frame must match parent's
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playlistFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackStateChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenToggleNotification:) name:MPMoviePlayerDidEnterFullscreenNotification object:player];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenToggleNotification:) name:MPMoviePlayerDidExitFullscreenNotification object:player];

            
            [player prepareToPlay];
            [player setContentURL:[NSURL URLWithString:file.url]];
            [player play];
            [self monitorPlaybackTime];

        
        } else {
          //  [player prepareToPlay];
            [player stop];
            [player setContentURL:[NSURL URLWithString:file.url]];
            [player play];
            [self monitorPlaybackTime];

            
        }
        [self setSelectedCellOfPlayingFileForPlayer:player];

    }

}
- (IBAction)didTouchDown:(id)sender{
    sliderIsTouched = YES;
    [_currentTimeLabel setHidden:NO];
}

- (IBAction)didTouchUp:(id)sender{
   // player.currentPlaybackTime = _slider.value;
    sliderIsTouched = NO;
    [_currentTimeLabel setHidden:YES];
    [self monitorPlaybackTime];
}

- (IBAction) sliderDidChangeValue:(id)sender{
    player.currentPlaybackTime = _slider.value;
    _currentTimeLabel.text = [StringUtils timeFormatted:_slider.value];
    
    _sliderMaxLabel.text = [StringUtils timeFormatted:player.duration - player.currentPlaybackTime];
    _sliderMinLabel.text = [StringUtils timeFormatted:player.currentPlaybackTime];


}

- (IBAction)goFullScreen:(id)sender {
    [player setFullscreen:YES animated:YES];
}


- (void)fullScreenToggleNotification:(NSNotification *)notification {
    if(player.isFullscreen){
        [player setControlStyle:MPMovieControlStyleDefault];
    } else {
        [player setControlStyle:MPMovieControlStyleNone];

    }

}

-(void)monitorPlaybackTime {
    
    if (sliderIsTouched)
    {
       return;
    }

    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = player.duration;
    self.totalVideoTime = player.duration;
    _slider.value = player.currentPlaybackTime;

    
    _sliderMaxLabel.text = [StringUtils timeFormatted:player.duration - player.currentPlaybackTime];
    _sliderMinLabel.text = [StringUtils timeFormatted:player.currentPlaybackTime];
    
    
    //NSLog(@"currenttime: %f   touched: %@", player.currentPlaybackTime, [NSString stringWithFormat:@"%@", sliderIsTouched ? @"YES" : @"NO"]);
    
    //keep checking for the end of video
    if ((self.totalVideoTime != 0 && player.currentPlaybackTime >= _totalVideoTime) || player.playbackState == MPMoviePlaybackStatePaused)
    {
       // [player pause];
      //  [btnPlay setImage:[UIImage imageNamed:@"UIButtonBarPlayGray.png"] forState:UIControlStateNormal];
       // btnPlay.tag = 0;
    }
    else
    {
        [self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:0.1];
    }
}


- (void) playBackStateChangeNotification:(NSNotification *)notification{
    switch(player.playbackState) {
        case MPMoviePlaybackStatePlaying: {
            
            // Turn on remote control event delivery
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            // Set itself as the first responder
            [self becomeFirstResponder];
            

            
            [_playPauseButton setImage:[UIImage imageNamed:@"pause-plainer.png"] forState:UIControlStateNormal];
            
            int index = [self indexOfInFileFromUrl:player.contentURL];
            PlayerFile *file = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            NSDictionary *songInfo;
            if(_backgroundImage.image){
               MPMediaItemArtwork *art = [[MPMediaItemArtwork alloc] initWithImage:_backgroundImage.image];
                songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             file.title, MPMediaItemPropertyTitle,
                             file.identifierTitle, MPMediaItemPropertyAlbumTitle,
                             file.displayOrder, MPMediaItemPropertyAlbumTrackNumber,
                             [NSString stringWithFormat:@"%i", [[self.fetchedResultsController fetchedObjects] count]], MPMediaItemPropertyAlbumTrackCount,
                             art, MPMediaItemPropertyArtwork,
                             nil];
            } else {
                songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             file.title, MPMediaItemPropertyTitle,
                             file.identifierTitle, MPMediaItemPropertyAlbumTitle,
                             file.displayOrder, MPMediaItemPropertyAlbumTrackNumber,
                             [NSString stringWithFormat:@"%i", [[self.fetchedResultsController fetchedObjects] count]], MPMediaItemPropertyAlbumTrackCount,
                             nil];
            }
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        }
            break;
            
        case MPMoviePlaybackStatePaused: {
            [_playPauseButton setImage:[UIImage imageNamed:@"play-plainer.png"] forState:UIControlStateNormal];

        }
            break;
        default:
            break;
            
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
            [self monitorPlaybackTime];

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
        [self monitorPlaybackTime];

        
    } else {
        return;
    }


}

- (void)playlistFinishedCallback:(NSNotification *)notification{
    
    MPMoviePlayerController *thePlayer = [notification object];
    NSNumber *finishReason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:thePlayer];
    } else {
        [self playNext];
    }
}

#pragma mark - controls

- (IBAction)doPlayPause:(id)sender{
    if(player){
        
        
        if(player.playbackState == MPMoviePlaybackStatePlaying){
            
            [player pause];
            
            
        } else if(player.playbackState == MPMoviePlaybackStatePaused){
            
            [player play];
            [self monitorPlaybackTime];

        } else if(player.playbackState == MPMoviePlaybackStateSeekingBackward || player.playbackState == MPMoviePlaybackStateSeekingForward){
            [player endSeeking];
            [player pause];
            
        } else if(player.playbackState == MPMoviePlaybackStateStopped){
            
            [player play];
            [self monitorPlaybackTime];

            
        }
    } else{
        if([[self.fetchedResultsController fetchedObjects] count] > 0){
            [self startListWithFile:[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
            [self setSelectedCellOfPlayingFileForPlayer:player];
        }
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






@end
