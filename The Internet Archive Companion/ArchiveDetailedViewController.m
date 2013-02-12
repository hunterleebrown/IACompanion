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
#import "StringUtils.h"
#import "ArchiveBookPageImageViewController.h"
#import "ArchivePageViewController.h"

@interface ArchiveDetailedViewController (){
    ArchiveFile *bookFile;
    int pageNumber;
    ArchiveBookPageImageViewController *nextController;
    ArchiveBookPageImageViewController *previousController;
    NSMutableArray *pages;
}
@end

@implementation ArchiveDetailedViewController

// http://ia700300.us.archive.org/zipview.php?zip=/9/items/adventhuckfinn00twairich/adventhuckfinn00twairich_jp2.zip

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
        
        pageNumber = 0;
        
        pages = [NSMutableArray new];
        
        // ...

        
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
    
    
    
    if(
       file.format == FileFormatH264 ||
       file.format == FileFormat512kbMPEG4 ||
       file.format == FileFormatMPEG4 ||
       file.format == FileFormatVBRMP3
       
       ){
        NSURL *movie = [NSURL URLWithString:file.url];
        
        NSLog(@"mp3: %@", file.url);
        player = [[MPMoviePlayerController alloc] initWithContentURL:movie];
        [player prepareToPlay];
        if(file.width){
            //   [self.movieView setFrame:CGRectMake(self.movieView.frame.origin.x, self.movieView.frame.origin.y, [file.width floatValue], [file.height floatValue])];
            //  [self.movieView setCenter:self.view.center];
        }
        [player.view setFrame: self.movieView.bounds];  // player's frame must match parent's
        [self.movieView addSubview: player.view];
        [player play];
        [player.view setBackgroundColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    }
    else {
        
        if(file.format == FileFormatJPEG || file.format == FileFormatGIF) {
            UIViewController *pushController = [UIViewController new];
            
            AsyncImageView *jpegView = [[AsyncImageView alloc]initWithFrame:pushController.view.bounds];
            [pushController setView:jpegView];
            [self.navigationController pushViewController:pushController animated:YES];
            [jpegView setAndLoadImageFromUrl:file.url];
            [jpegView setContentMode:UIViewContentModeScaleAspectFit];
            [pushController setTitle:file.name];
        } else if(file.format == FileFormatProcessedJP2ZIP) {

            
            //[self.navigationController pushViewController:page animated:YES];
            bookFile = file;
            
            [self performSegueWithIdentifier:@"bookViewer" sender:bookFile];
            
        }
    
    
    }


}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"bookViewer"]){
        ArchiveBookPageImageViewController *page = [[ArchiveBookPageImageViewController alloc] initWithNibName:@"ArchiveBookPageImageViewController" bundle:nil];
        [page setPageWithServer:bookFile.server withZipFileLocation:[NSString stringWithFormat:@"%@/%@", bookFile.directory, bookFile.name] withFileName:bookFile.name withIdentifier:_identifier withIndex:0];
        
        ArchivePageViewController *bookViewController = [segue destinationViewController];
        [bookViewController setDataSource:self];
        [bookViewController setViewControllers:@[page] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        
        
        [pages setObject:page atIndexedSubscript:0];
        
        nextController = [[ArchiveBookPageImageViewController alloc] initWithNibName:@"ArchiveBookPageImageViewController" bundle:nil];
        [nextController setPageWithServer:bookFile.server withZipFileLocation:[NSString stringWithFormat:@"%@/%@", bookFile.directory, bookFile.name] withFileName:bookFile.name withIdentifier:_identifier withIndex:1];
        [pages setObject:nextController atIndexedSubscript:1];
  
        
        
        
    }
}


#pragma mark - page view controller

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ArchiveBookPageImageViewController *)viewController{
    
    ArchiveBookPageImageViewController *page = [[ArchiveBookPageImageViewController alloc] initWithNibName:@"ArchiveBookPageImageViewController" bundle:nil];
    [page setPageWithServer:bookFile.server withZipFileLocation:[NSString stringWithFormat:@"%@/%@", bookFile.directory, bookFile.name] withFileName:bookFile.name withIdentifier:_identifier withIndex:(viewController.index + 2)];
  
    [pages setObject:page atIndexedSubscript:(viewController.index + 2)];
    
    
    
    return [pages objectAtIndex:(viewController.index + 1)];

}


- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ArchiveBookPageImageViewController *)viewController{
    
    if(viewController.index == 1){
        return [pages objectAtIndex:0];
    
    } else if(viewController.index == 0){
        return nil;
        
    } else{
    
    
        ArchiveBookPageImageViewController *page = [[ArchiveBookPageImageViewController alloc] initWithNibName:@"ArchiveBookPageImageViewController" bundle:nil];
        [page setPageWithServer:bookFile.server withZipFileLocation:[NSString stringWithFormat:@"%@/%@", bookFile.directory, bookFile.name] withFileName:bookFile.name withIdentifier:_identifier withIndex:(viewController.index - 2)];
    
        [pages setObject:page atIndexedSubscript:(viewController.index - 2)];
    
    
        return [pages objectAtIndex:(viewController.index - 1)];
    }
}



- (void)playbackDidFinish:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    for (id subview in _description.subviews) {
  
        
        if ([subview isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)subview).hidden = YES;
        }
        
    }
    
    
    

}

- (void) viewWillDisappear:(BOOL)animated{
    if(!player.fullscreen){
        [player stop];
    }

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //[player.view setFrame: self.movieView.bounds];  // player's frame must match parent's
}


#pragma mark - data call back

- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    _doc = [[results objectForKey:@"documents"] objectAtIndex:0];
    _docTitle.text = [StringUtils stringFromObject:_doc.title];
    
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", _doc.description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [_description loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                      MIMEType:@"text/html"
              textEncodingName:@"UTF-8"
                       baseURL:theBaseURL];
    
    
    for(ArchiveFile *file in _doc.files){
       // NSLog(@"file %@%@/%@", file.server, file.directory, file.name);
        
        if(file.format != FileFormatOther){
            [vbrs addObject:file];
        }
    }
    if(vbrs.count > 0){
        [_tableView reloadData];
    
    }
    
    [self.aSyncImage setAndLoadImageFromUrl:_doc.headerImageUrl];
    
    NSDictionary *metadata = [_doc.rawDoc objectForKey:@"metadata"];
    
    if([metadata objectForKey:@"subject"]){
        [self.subject setText:[StringUtils stringFromObject:[metadata objectForKey:@"subject"]]];
    }
    
    
    
    if([metadata objectForKey:@"publicdate"]){
        [self.added setText:[StringUtils displayDateFromArchiveMetaDateString:[metadata objectForKey:@"publicdate"]]];
        
        
    }
    if([metadata objectForKey:@"addeddate"]){
        [self.from setText:[StringUtils displayDateFromArchiveMetaDateString:[metadata objectForKey:@"addeddate"]]];
    }
    if([metadata objectForKey:@"publisher"]){
        [self.publisher setText:[StringUtils stringFromObject:[metadata objectForKey:@"publisher"]]];
    }
    

    
    
    if([metadata objectForKey:@"creator"]){
        [self.creator setText:[StringUtils stringFromObject:[metadata objectForKey:@"creator"]]];
    }
    
    
    
    
    if([metadata objectForKey:@"uploader"]){
        [self.uploader setText:[StringUtils stringFromObject:[metadata objectForKey:@"uploader"]]];
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
