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
    ArchivePageViewController *bookViewController;
    ArchiveBookPageImageViewController *firstPage;
    NSMutableArray *pages;
    NSMutableDictionary *pageDictionary;
    
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
        
        
        pages = [NSMutableArray new];
        pageDictionary = [NSMutableDictionary new];

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
       //NSURL *movie = [NSURL URLWithString:file.url];
        
        NSLog(@"mp3: %@", file.url);
        /*player = [[MPMoviePlayerController alloc] initWithContentURL:movie];
        [player prepareToPlay];
        if(file.width){
            //   [self.movieView setFrame:CGRectMake(self.movieView.frame.origin.x, self.movieView.frame.origin.y, [file.width floatValue], [file.height floatValue])];
            //  [self.movieView setCenter:self.view.center];
        }
        [player.view setFrame: self.movieView.bounds];  // player's frame must match parent's
        [self.movieView addSubview: player.view];
        [player play];
        [player.view setBackgroundColor:[UIColor clearColor]];
        */
        
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToPlayerListFileNotification" object:file];

        
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
            
            bookFile = file;
            [self performSegueWithIdentifier:@"bookViewer" sender:bookFile];
            
        }
    
    
    }


}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"bookViewer"]){
        [self setPagesWithIndex:0];
        firstPage = [pages objectAtIndex:1];
        
        bookViewController = [segue destinationViewController];
        [bookViewController setDataSource:self];
        [bookViewController setDelegate:self];
        [bookViewController setViewControllers:@[firstPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        
        [pages setObject:firstPage atIndexedSubscript:0];
     

  
        
        
        
    }
}


#pragma mark - page view controller
/* Stupid, but works */

- (ArchiveBookPageImageViewController *) pageControllerForIndex:(int)index{
    
    NSLog(@"-----> pages.count: %i   index:%i", pages.count, index);
    
    ArchiveBookPageImageViewController *p0;
    ArchiveBookPageImageViewController *p1;
    ArchiveBookPageImageViewController *p2;
    
    if([pages objectAtIndex:0]){
        p0 = [pages objectAtIndex:0];
        NSLog(@"p0.index: %i", p0.index);
    }
    if([pages objectAtIndex:1]){
        p1 = [pages objectAtIndex:1];
        NSLog(@"p1.index: %i", p1.index);

    }
    if([pages objectAtIndex:2]){
        p2 = [pages objectAtIndex:2];
        NSLog(@"p2.index: %i", p2.index);

    }
    
    
    if(p0.index == index){
        NSLog(@"--> 0 HIT");
        [self setPagesWithIndex:index];
        return p0;
    }
    else if(p1.index == index){
        NSLog(@"--> 1 HIT");
        [self setPagesWithIndex:index];
        return p1;
    }
    else if(p2.index == index){
        NSLog(@"--> 2 HIT");
        [self setPagesWithIndex:index];
        return p2;
    }
    else {
        NSLog(@"--> go fish");
        [self setPagesWithIndex:index];
        return [pages objectAtIndex:1];
    }
    
    
}

- (void) setPagesWithIndex:(int)index{
    [pages setObject:[self newPageControllerWithIndex:index - 1] atIndexedSubscript:0];
    [pages setObject:[self newPageControllerWithIndex:index] atIndexedSubscript:1];
    [pages setObject:[self newPageControllerWithIndex:index + 1] atIndexedSubscript:2];

}


- (ArchiveBookPageImageViewController *) newPageControllerWithIndex:(int)index{

    ArchiveBookPageImageViewController *page = [[ArchiveBookPageImageViewController alloc] initWithNibName:@"ArchiveBookPageImageViewController" bundle:nil];
    [page setPageWithServer:bookFile.server withZipFileLocation:[NSString stringWithFormat:@"%@/%@", bookFile.directory, bookFile.name] withFileName:bookFile.name withIdentifier:_identifier withIndex:index];
    return page;
}





- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ArchiveBookPageImageViewController *)viewController{
    
    NSLog(@"---> currentIndex: %i", viewController.index);


    return [self pageControllerForIndex:viewController.index + 1];
}


- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ArchiveBookPageImageViewController *)viewController{
    
    NSLog(@"---> currentIndex: %i", viewController.index);
    
    
    if(viewController.index == 0){
        return firstPage;
    } else{

        return [self pageControllerForIndex:viewController.index - 1];

    }
}



- (void)playbackDidFinish:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - orientation
/*
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        if(bookViewController){
            [bookViewController setDoubleSided:YES];
        }
    } else {
        if(bookViewController){
            [bookViewController setDoubleSided:NO];
        }
    }
}
*/

#pragma mark - page view controller spine
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if(UIInterfaceOrientationIsLandscape(orientation)){
        
        
        NSArray *viewControllers = nil;
        ArchiveBookPageImageViewController *currentViewController = (ArchiveBookPageImageViewController*)[pages objectAtIndex:1];
        
        NSLog(@"-------> controller index: %i", ((ArchiveBookPageImageViewController*)[pages objectAtIndex:1]).index);
        
        
        NSUInteger currentIndex = currentViewController.index;
        if(currentIndex == 0 || currentIndex %2 == 0)
        {
            UIViewController *nextViewController = [self pageViewController:bookViewController viewControllerAfterViewController:currentViewController];
            
            viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
        }
        else
        {
            UIViewController *previousViewController = [self pageViewController:bookViewController viewControllerBeforeViewController:currentViewController];
            
            viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
        }
        [bookViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        return UIPageViewControllerSpineLocationMid;
    } else {
        
        
        ArchiveBookPageImageViewController *currentViewController = (ArchiveBookPageImageViewController*)[pages objectAtIndex:1];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [bookViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        bookViewController.doubleSided = NO;
        
        return UIPageViewControllerSpineLocationMin;
    }

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
    
    
    NSMutableArray *files = [NSMutableArray new];
    for(ArchiveFile *file in _doc.files){
       // NSLog(@"file %@%@/%@", file.server, file.directory, file.name);
        
        if(file.format != FileFormatOther){
            [files addObject:file];
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"track" ascending:YES];
    [vbrs addObjectsFromArray:[files sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
    
    
    
    if(vbrs.count > 0){
        [_tableView reloadData];
    
    }
    
    [self.aSyncImage setAndLoadImageFromUrl:_doc.headerImageUrl];
    
    NSDictionary *metadata = [_doc.rawDoc objectForKey:@"metadata"];
    
    if([metadata objectForKey:@"subject"]){
        [self.subject setText:[StringUtils stringFromObject:[metadata objectForKey:@"subject"]]];
    }
    
    
        
    [self.metadataTableView setMetadata:[_doc.rawDoc objectForKey:@"metadata"]];

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

- (IBAction)openWebPage:(id)sender{
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://archive.org/details/%@", _identifier]];
    [[UIApplication sharedApplication] openURL:aUrl];

}


@end
