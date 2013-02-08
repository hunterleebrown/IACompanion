//
//  ArchiveDetailedViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/31/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDetailedViewController.h"
#import "ArchiveFile.h"
#import "ArchiveFileTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ArchiveDetailedViewController ()

@end

@implementation ArchiveDetailedViewController



- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        vbrs = [NSMutableArray new];
        
        service = [ArchiveDataService new];
        [service setDelegate:self];
        
    }
    return self;
}


#pragma mark - table shit

- (int) numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return vbrs.count;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchiveFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playableFileCell"];
 
    ArchiveFile *file = [vbrs objectAtIndex:indexPath.row];
   
    [cell.fileTitle setText:file.title];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchiveFile *file = [vbrs objectAtIndex:indexPath.row];
    
    

    NSURL *movie = [NSURL URLWithString:file.url];
    
   NSLog(@"mp3: %@", file.url);
    
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:movie];
    //[mp.navigationController.toolbar setHidden:YES];
    
    [self.navigationController pushViewController:mp animated:NO];
    [mp.moviePlayer play];
    [mp.navigationController setNavigationBarHidden:YES];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:mp.moviePlayer];

    
    
}


- (void)playbackDidFinish:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}


#pragma mark - data call back

- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    _doc = [[results objectForKey:@"documents"] objectAtIndex:0];
    _docTitle.text = _doc.title;
    
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#666; font-size:14px; font-family:sans-serif'>%@</body></html>", _doc.description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [_description loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                      MIMEType:@"text/html"
              textEncodingName:@"UTF-8"
                       baseURL:theBaseURL];
    
    
    for(ArchiveFile *file in _doc.files){
        if(file.format == FileFormatVBRMP3 || file.format == FileFormatH264 || file.format == FileFormatMPEG4){
            [vbrs addObject:file];
        }
    }
    if(vbrs.count > 0){
        [_tableView reloadData];
    
    }
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setIdentifier:(NSString *)identifier{
    _identifier = identifier;
    [service getMetadataDocsWithIdentifier:identifier];

}


@end
