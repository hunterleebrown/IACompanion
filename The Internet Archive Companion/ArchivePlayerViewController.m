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




@interface ArchivePlayerViewController () {
    NSMutableArray *playerFiles;
    MPMoviePlayerController *player;
    BOOL tableIsEditing;

}

@end

@implementation ArchivePlayerViewController

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
        playerFiles = [NSMutableArray new];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFile:) name:@"AddToPlayerListFileNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToPlayerListFileAndPlay:) name:@"AddToPlayerListFileAndPlayNotification" object:nil];

        
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
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    
  }




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_numberOfFiles setTitle:[NSString stringWithFormat:@"%i file%@", playerFiles.count, playerFiles.count == 1 ? @"": @"s"]];
    return playerFiles.count;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchivePlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
    
    ArchiveFile *file = [playerFiles objectAtIndex:indexPath.row];
    
    cell.fileTitle.text = file.title;
    cell.identifierLabel.text = file.identifierTitle;
    cell.fileFormat.text = [file.file objectForKey:@"format"];
    cell.showsReorderControl = YES;
    [cell setFile:file];
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [playerFiles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [tableView reloadData];

    }
    
    
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSLog(@"->      sourceIndexPath.row: %i", sourceIndexPath.row);
    NSLog(@"-> destinationIndexPath.row: %i", destinationIndexPath.row);
    
    /*
    for(ArchiveFile *file in playerFiles){
        NSLog(@"index: %i  %@", [playerFiles indexOfObject:file], file.title);
    }
    */

    /* man this is way too easy */
    id object = [playerFiles objectAtIndex:sourceIndexPath.row];
    [playerFiles removeObjectAtIndex:sourceIndexPath.row];
    [playerFiles insertObject:object atIndex:destinationIndexPath.row];

    /*
    NSLog(@" <   ---   > ");
    
    for(ArchiveFile *file in playerFiles){
        NSLog(@"index: %i  %@", [playerFiles indexOfObject:file], file.title);
    }
     */
    
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(player){
        [player stop];
    }
    ArchiveFile *file = ((ArchivePlayerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).file;

    [self startListWithFile:file];

}

- (IBAction)editList:(id)sender{
    tableIsEditing = !tableIsEditing;
    [_editListButton setTitle:tableIsEditing ? @"Done" : @"Edit"];
    [_playerTableView setEditing:tableIsEditing animated:YES];
    if(player){
        [self setSelectedCellOfPlayingFileForPlayer:player];
    }

}

- (IBAction)clearList:(id)sender{
    [playerFiles removeAllObjects];
    [_playerTableView reloadData];

}


- (void) addToPlayerListFileAndPlay:(NSNotification *)notification{    
    [self addToPlayerListFile:notification];
    ArchiveFile *file = notification.object;
    [self startListWithFile:file];
}


- (void) addToPlayerListFile:(NSNotification *)notification{
    ArchiveFile *file = notification.object;
    [playerFiles addObject:file];
    [_playerTableView reloadData];

}

- (IBAction)hidePlayer:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePlayerNotification" object:nil];

}


- (BOOL) shouldAutorotate{
    return YES;
}

- (int) indexOfInFileFromUrl:(NSURL *)url{
    
    for(ArchiveFile *file in playerFiles){
        if([file.url isEqualToString:url.absoluteString]){
            return [playerFiles indexOfObject:file];
        }
        
    }
    return -1;
}


- (void) setSelectedCellOfPlayingFileForPlayer:(MPMoviePlayerController *)thePlayer{
    if (playerFiles.count > 0) {
        int index = [self indexOfInFileFromUrl:thePlayer.contentURL];
        NSLog(@"--------> playing index: %i", index);
        
        if([_playerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]]){
            [_playerTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
        ArchiveFile *file = [playerFiles objectAtIndex:index];
        [_backgroundImage setAndLoadImageFromUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", file.identifier]];
        [_instructions setHidden:YES];
    }

}

- (void)startListWithFile:(ArchiveFile *)file{
    if(playerFiles.count > 0){
        if(!player){
            player = [[MPMoviePlayerController alloc] init];
            [player.view setBackgroundColor:[UIColor clearColor]];
            [self.playerHolder addSubview: player.view];
            [player.view setFrame: self.playerHolder.bounds];  // player's frame must match parent's
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playlistFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];

            [player prepareToPlay];
            [player setContentURL:[NSURL URLWithString:file.url]];
            [player play];
        
        } else {
            [player prepareToPlay];
            [player setContentURL:[NSURL URLWithString:file.url]];
            [player play];
            
        }
        [self setSelectedCellOfPlayingFileForPlayer:player];
    
    }

}




- (ArchiveFile *) playingFile{
    int index = [self indexOfInFileFromUrl:player.contentURL];
    ArchiveFile *f = [playerFiles objectAtIndex:index];
    return f;
}


- (void) playNext{
    int index = [self indexOfInFileFromUrl:player.contentURL];
    if(index >= 0) {
        int newIndex = index +1;
        if(newIndex == [playerFiles count]){
            // Remove this class from the observers
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                                          object:player];
        } else {
            ArchiveFile *newFile = [playerFiles objectAtIndex:newIndex];
            [player setContentURL:[NSURL URLWithString:newFile.url]];
            [player play];
            [self setSelectedCellOfPlayingFileForPlayer:player];
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
        ArchiveFile *newFile = [playerFiles objectAtIndex:newIndex];
        [player setContentURL:[NSURL URLWithString:newFile.url]];
        [player play];
        [self setSelectedCellOfPlayingFileForPlayer:player];
        
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
        } else if(player.playbackState == MPMoviePlaybackStateSeekingBackward || player.playbackState == MPMoviePlaybackStateSeekingForward){
            [player endSeeking];
        } else if(player.playbackState == MPMoviePlaybackStateStopped){
            
            [player play];
        }
    } else{
        if(playerFiles.count > 0){
            
            [self startListWithFile:[playerFiles objectAtIndex:0]];
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
