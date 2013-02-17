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
    return playerFiles.count;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchivePlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
    
    ArchiveFile *file = [playerFiles objectAtIndex:indexPath.row];
    
    cell.fileTitle.text = file.title;
    cell.identifierLabel.text = file.identifierTitle;
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


}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(player){
        [player stop];
    }
    ArchiveFile *file = ((ArchivePlayerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).file;
    player = [[MPMoviePlayerController alloc] init];
    [self.playerHolder addSubview: player.view];
    
    [player.view setFrame: self.playerHolder.bounds];  // player's frame must match parent's

    [player prepareToPlay];
    [player setContentURL:[NSURL URLWithString:file.url]];
    [player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playlistFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];


}

- (IBAction)editList:(id)sender{
    tableIsEditing = !tableIsEditing;
    [_editListButton setTitle:tableIsEditing ? @"Done" : @"Edit"];
    [_playerTableView setEditing:tableIsEditing animated:YES];

}

- (IBAction)clearList:(id)sender{
    [playerFiles removeAllObjects];
    [_playerTableView reloadData];

}


- (void) addToPlayerListFile:(NSNotification *)notification{
    ArchiveFile *file = notification.object;
    [playerFiles addObject:file];
    [_playerTableView reloadData];

}

- (IBAction)hidPlayer:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePlayerNotification" object:nil];

}


- (int) indexOfInVideoItemFromUrl:(NSURL *)url{
    
    for(ArchiveFile *file in playerFiles){
        if([file.url isEqualToString:url.absoluteString]){
            return [playerFiles indexOfObject:file];
        }
        
    }
    return -1;
}

- (void)playlistFinishedCallback:(NSNotification *)notification{
    
    MPMoviePlayerController *moviePlayer = [notification object];
    NSNumber *finishReason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
    } else {
        int index = [self indexOfInVideoItemFromUrl:moviePlayer.contentURL];
        if(index >= 0) {
            int newIndex = index +1;
            if(newIndex == [playerFiles count]){
                // Remove this class from the observers
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                                              object:moviePlayer];
                
                // Dismiss the view controller
                
            } else {
                ArchiveFile *newFile = [playerFiles objectAtIndex:newIndex];
                [player setContentURL:[NSURL URLWithString:newFile.url]];
                [player play];
                
                if([_playerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0]]){
                    [_playerTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
            }
            
        } else {
            return;
        }
    }
}




@end
