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
#import "BufferingView.h"
#import "StringUtils.h"
#import "FontMapping.h"
#import "MediaUtils.h"
#import "AppCoreDataManager.h"

@interface MediaPlayerViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet ArchiveImageView *imageView;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, retain) IBOutlet UITableView *playerTableView;

@property (nonatomic, weak) IBOutlet UIButton *ffButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *rwButton;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;


@property (nonatomic, weak) IBOutlet UIView *playerHolder;
@property (nonatomic) BOOL tableIsEditing;
@property (nonatomic, weak) IBOutlet UIButton *editListButton;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;

@property (nonatomic, weak) IBOutlet BufferingView *bufferingView;

@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *sliderMinLabel;
@property (nonatomic, weak) IBOutlet UILabel *sliderMaxLabel;
@property (nonatomic, weak) IBOutlet UISlider *slider;

@property (nonatomic, weak) IBOutlet UIView *sliderHolder;
@property (nonatomic) BOOL sliderIsTouched;
@property (nonatomic, assign) NSTimeInterval totalVideoTime;


@property (nonatomic, weak) IBOutlet UIButton *closeButtonButton;
@property (nonatomic, weak) IBOutlet UIButton *mediaPlayerButton;



@property (nonatomic, weak) IBOutlet UIImageView *topEqualizerImage;

@property (nonatomic) BOOL shouldUpdateSpeaker;
@property (nonatomic, strong) NSArray *speakerArray;

@property (nonatomic, weak) IBOutlet UIView *topTitleHolderView;
@property (nonatomic, weak) IBOutlet UILabel *topTitle;
@property (nonatomic, weak) IBOutlet UIButton *topMediaPlayerButton;



@end

@implementation MediaPlayerViewController


@synthesize player, imageView, playButton, playerHolder, tableIsEditing, bufferingView, sliderIsTouched;

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
    [player.view setUserInteractionEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFileAndPlayNotification:) name:@"AddToPlayerListFileAndPlayNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFileNotification:) name:@"AddToPlayerListFileNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerLoadStateNotification:) name:@"MPMoviePlayerLoadStateDidChangeNotification" object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackStateChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenToggleNotification:) name:MPMoviePlayerDidEnterFullscreenNotification object:player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenToggleNotification:) name:MPMoviePlayerDidExitFullscreenNotification object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playlistFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];

    
    tableIsEditing = NO;
    
    [playerHolder bringSubviewToFront:bufferingView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSlider)];
    [tapRecognizer setDelegate:self];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [player.view addGestureRecognizer: tapRecognizer];

    sliderIsTouched = NO;

    [self.closeButtonButton setTitle:CLOSE forState:UIControlStateNormal];
    [self.playButton setTitle:PLAY forState:UIControlStateNormal];
    [self.ffButton setTitle:FFORWARD forState:UIControlStateNormal];
    [self.rwButton setTitle:RREVERSE forState:UIControlStateNormal];
    [self.fullScreenButton setTitle:FULLSCREEN forState:UIControlStateNormal];


    [self.playerToolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];

    [self.playerToolbar setBackgroundColor:[UIColor clearColor]];

    [self.topMediaPlayerButton setTitle:PLAY forState:UIControlStateNormal];

    [self animateEqualizerBarSetUp];
    self.topEqualizerImage.hidden = YES;
    
    
}

- (void)animateEqualizerBarSetUp
{
    self.topEqualizerImage.animationImages = @[[UIImage imageNamed:@"Equalizer01"],
                                               [UIImage imageNamed:@"Equalizer02"],
                                               [UIImage imageNamed:@"Equalizer03"],
                                               [UIImage imageNamed:@"Equalizer04"],
                                               [UIImage imageNamed:@"Equalizer05"]
                                               ];
    
    self.topEqualizerImage.animationRepeatCount = 0;
    self.topEqualizerImage.animationDuration = 0.55;
    
}



- (void)animateEqualizer:(BOOL)shouldAnimate
{
    self.topEqualizerImage.hidden = !shouldAnimate;
    self.topEqualizerImage.hidden ? [self.topEqualizerImage stopAnimating] : [self.topEqualizerImage startAnimating];
}


- (IBAction)togglePlayer:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleMediaPlayer" object:nil];

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void) viewDidAppear:(BOOL)animated{
    player.view.frame = CGRectMake(0, 0, playerHolder.frame.size.width, playerHolder.frame.size.height);
    
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    player.view.frame = CGRectMake(0, 0, playerHolder.frame.size.width, playerHolder.frame.size.height);

}

#pragma mark - gesture delegate
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    
    return YES;
}


- (void) toggleSlider{
    
    
    if(_sliderHolder.hidden){
        [self showSlider];
    } else {
        [self hideSlider];
    }

}

- (void) hideSlider {
    [UIView animateWithDuration:0.33 animations:^{
        [_sliderHolder setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_sliderHolder setHidden:YES];
    }];
}

- (void) showSlider {
    [_sliderHolder setHidden:NO];

    [UIView animateWithDuration:0.33 animations:^{
        [_sliderHolder setAlpha:1.0];
    }];
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


- (void)playlistFinishedCallback:(NSNotification *)notification{
    
    NSNumber *finishReason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {

    } else {
        [self playNext];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePlayer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMediaPlayer" object:nil];
}


- (IBAction)goFullScreen:(id)sender {
    [player setFullscreen:YES animated:YES];
}


- (void)fullScreenToggleNotification:(NSNotification *)notification {
    if(player.isFullscreen){
        [player setControlStyle:MPMovieControlStyleDefault];
    } else {
        [player setControlStyle:MPMovieControlStyleNone];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];

        
    }
    player.view.frame = CGRectMake(0, 0, playerHolder.frame.size.width, playerHolder.frame.size.height);

}

#pragma mark - playback delegates

- (void) playerLoadStateNotification:(NSNotification *)notification {
    MPMoviePlayerController *p = [notification object];
    NSLog(@"--> loadstate: %lu", p.loadState);
    
    MPMovieLoadState state = [p loadState];
    if((state & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable) {
        [bufferingView stopAnimating];
        [self updateRemote];
    } else if ((state & MPMovieLoadStateUnknown) == MPMovieLoadStateUnknown) {
        [bufferingView stopAnimating];

    }  else {
        [bufferingView startAnimating];

    }
    
    if((state & MPMovieLoadStateStalled) == MPMovieLoadStateStalled) {
        [bufferingView startAnimating];


    }

}

- (void) playBackStateChangeNotification:(NSNotification *)notification{
    switch(player.playbackState) {
        case MPMoviePlaybackStatePlaying:
            [self monitorPlaybackTime];

            // Turn on remote control event delivery
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            // Set itself as the first responder
            [self becomeFirstResponder];
            [playButton setTitle:PAUSE forState:UIControlStateNormal];
            [self.topMediaPlayerButton setTitle:PAUSE forState:UIControlStateNormal];

            [self animateEqualizer:YES];

            break;
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
            [playButton setTitle:PLAY forState:UIControlStateNormal];
            [self.topMediaPlayerButton setTitle:PLAY forState:UIControlStateNormal];

            
            [self animateEqualizer:NO];

            break;
        default:
            break;
            
    }
    
}




- (void)updateRemote
{
    NSInteger index = [self indexOfInFileFromUrl:player.contentURL];
    PlayerFile *file = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSDictionary *songInfo;
    
    self.topTitle.text = file.title;
    
    
    if(imageView.image){
        MPMediaItemArtwork *art = [[MPMediaItemArtwork alloc] initWithImage:imageView.image];
        songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    file.title, MPMediaItemPropertyTitle,
                    file.identifierTitle, MPMediaItemPropertyAlbumTitle,
                    file.displayOrder, MPMediaItemPropertyAlbumTrackNumber,
                    [NSString stringWithFormat:@"%lu", (unsigned long)[[self.fetchedResultsController fetchedObjects] count]], MPMediaItemPropertyAlbumTrackCount,
                    art, MPMediaItemPropertyArtwork,
                    [NSNumber numberWithDouble:player.duration], MPMediaItemPropertyPlaybackDuration,
                    nil];
    } else {
        songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    file.title, MPMediaItemPropertyTitle,
                    file.identifierTitle, MPMediaItemPropertyAlbumTitle,
                    file.displayOrder, MPMediaItemPropertyAlbumTrackNumber,
                    [NSString stringWithFormat:@"%lu", (unsigned long)[[self.fetchedResultsController fetchedObjects] count]], MPMediaItemPropertyAlbumTrackCount,
                    [NSNumber numberWithDouble:player.duration], MPMediaItemPropertyPlaybackDuration,
                    nil];
    }

    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    

}


#pragma mark - Remote Control Events

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {

    if (receivedEvent.type == UIEventTypeRemoteControl) {
        NSLog(@"--------->%li", receivedEvent.subtype );
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
                [self doPlayPause:nil];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self doPlayPause:nil];
                break;
            case UIEventSubtypeRemoteControlStop:
                [self doPlayPause:nil];
                break;
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


- (void)startListWithFile:(PlayerFile *)file{
    if([[self.fetchedResultsController fetchedObjects] count] > 0){
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


- (void)clearPlayerFiles
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context processPendingChanges];
    
    for(PlayerFile *f in [self.fetchedResultsController fetchedObjects]){
        [context deleteObject:f];
    }
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [player stop];
    [player setContentURL:nil];
    [imageView setImage:nil];
}


- (IBAction)clearList:(id)sender{
    if(self.fetchedResultsController.fetchedObjects.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Playlist" message:@"Do you want to clear your playlist?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self clearPlayerFiles];
    }
}


- (IBAction)editList:(id)sender{
    tableIsEditing = !tableIsEditing;
    [_editListButton.titleLabel setText:tableIsEditing ? @"Done" : @"Edit"];
    [_playerTableView setEditing:tableIsEditing animated:YES];
    if(player){
        // [self setSelectedCellOfPlayingFileForPlayer:player];
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

- (void) addToPlayerListFileNotification:(NSNotification *)notification{
    ArchiveFile *file = notification.object;
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    
    [newManagedObject setValue:file.title forKey:@"title"];
    [newManagedObject setValue:file.identifier forKey:@"identifier"];
    [newManagedObject setValue:file.url forKey:@"url"];
    [newManagedObject setValue:file.identifierTitle forKey:@"identifierTitle"];
    [newManagedObject setValue:[file.file objectForKey:@"format"] forKey:@"format"];
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


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}

- (void)configureCell:(PlayerTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PlayerFile *file = (PlayerFile *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.identifier = file.identifier;
    cell.mediaPlayerViewController = self;
    
    cell.fileTitle.text = file.title;
    cell.identifierLabel.text = file.identifierTitle;
    cell.format = file.format;

    cell.showsReorderControl = YES;
    [cell setFile:file];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - table stuff

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
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
        zePlayerFile.displayOrder = [NSNumber numberWithInteger:idx];
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
    
    
    _fetchedResultsController = [[AppCoreDataManager sharedInstance] fetchedResultsControllerForSchema:@"PlayerFile" cacheName:@"Master" delegate:self];
    
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
        default:
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

- (NSInteger) indexOfInFileFromUrl:(NSURL *)url{
    
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
        NSInteger index = [self indexOfInFileFromUrl:thePlayer.contentURL];
        //NSLog(@"--------> playing index: %i", index);
        
        // if([_playerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]]){
        [_playerTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        
        //  }
        
        //        PlayerFile *file = [self.fetchedResultsController objectAtIndex:index];
        
        
        PlayerFile *file = (PlayerFile *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];

        
        ArchiveImage *mediaPicture = [[ArchiveImage alloc] initWithUrlPath:[NSString stringWithFormat:@"http://archive.org/services/img/%@", file.identifier]];
        [imageView setArchiveImage:mediaPicture];
        
        
        //[_instructions setHidden:YES];
        
//        [playButton setImage:[UIImage imageNamed:@"pause-button.png"] forState:UIControlStateNormal];
        [playButton setTitle:PAUSE forState:UIControlStateNormal];
        [bufferingView startAnimating];
        
        
    }
    
}


#pragma mark - controls

- (IBAction)doPlayPause:(id)sender{
    
    
    if(player.playbackState == MPMoviePlaybackStatePlaying){
        
        [player pause];
//        [playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];

       // [bufferingView stopAnimating];

        [playButton setTitle:PLAY forState:UIControlStateNormal];
        
    } else if(player.playbackState == MPMoviePlaybackStatePaused){
        
        [player play];
        [playButton setTitle:PAUSE forState:UIControlStateNormal];


    } else if(player.playbackState == MPMoviePlaybackStateSeekingBackward || player.playbackState == MPMoviePlaybackStateSeekingForward){
        [player endSeeking];
        [player pause];
        [playButton setTitle:PLAY forState:UIControlStateNormal];

        
    } else if(player.playbackState == MPMoviePlaybackStateStopped){
        
        [player play];
        [playButton setTitle:PAUSE forState:UIControlStateNormal];

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
    NSInteger index = [self indexOfInFileFromUrl:player.contentURL];
    
    
    
    if(index >= 0) {
        NSInteger newIndex = index +1;
        if(newIndex == [[self.fetchedResultsController fetchedObjects ]count]){
            
        } else {
            [player stop];
            PlayerFile *newFile = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0]];
            [player setContentURL:[NSURL URLWithString:newFile.url]];
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
    NSInteger index = [self indexOfInFileFromUrl:player.contentURL];
    if(index > 0) {
        NSInteger newIndex = index - 1;
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
}

@end
