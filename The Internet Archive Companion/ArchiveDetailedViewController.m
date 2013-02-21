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
#import "ArchiveShareViewController.h"
#import "ArchiveImageViewController.h"
#import "HomeCollectionViewController.h"
#import "ArchivePhoneExtraDetailsViewController.h"

@interface ArchiveDetailedViewController (){
    ArchiveFile *bookFile;
    ArchivePageViewController *bookViewController;
    ArchiveBookPageImageViewController *firstPage;
    NSMutableArray *pages;
    NSMutableDictionary *pageDictionary;
    ArchiveFile *sharedPhotoFile;
    
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
       file.format == FileFormatVBRMP3 ||
       file.format == FileFormat64KbpsMP3
       ){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToPlayerListFileNotification" object:file];

    }
    else {
        
        if(file.format == FileFormatJPEG || file.format == FileFormatGIF) {
            sharedPhotoFile = file;
            [self performSegueWithIdentifier:@"imageSegue" sender:sharedPhotoFile];
        } else if(file.format == FileFormatProcessedJP2ZIP) {
            bookFile = file;
            [self performSegueWithIdentifier:@"bookViewer" sender:bookFile];
        }
    }
}

- (void) sharePhoto{
    [self performSegueWithIdentifier:@"sharePopover" sender:nil];
}


- (IBAction)addFilesToPlayer:(id)sender{
    
    for(ArchiveFile *file in vbrs){        
        if(
           file.format == FileFormatH264 ||
           file.format == FileFormat512kbMPEG4 ||
           file.format == FileFormatMPEG4 ||
           file.format == FileFormatVBRMP3 ||
           file.format == FileFormat64KbpsMP3
           ){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToPlayerListFileNotification" object:file];

        }
    }

}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"bookViewer"]){
        [self setPagesWithIndex:0];
        firstPage = [pages objectAtIndex:2];
        
        bookViewController = [segue destinationViewController];
        [bookViewController setDataSource:self];
        [bookViewController setDelegate:self];
        [bookViewController setViewControllers:@[firstPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        
        [pages setObject:firstPage atIndexedSubscript:0];
        
    }
    if([[segue identifier] isEqualToString:@"sharePopover"]){
        
        ArchiveShareViewController *shareController = [segue destinationViewController];
        UIPopoverController *pop = ((UIStoryboardPopoverSegue *)segue).popoverController;
        [shareController setMyPopOverController:pop];
        [shareController setArchiveIdentifier:self.identifier];
        [shareController setArchiveTitle:[StringUtils stringFromObject:_doc.title]];
        [shareController setImage:_aSyncImage.image];
        
    }
    if([[segue identifier] isEqualToString:@"shareModal"]){
        
        ArchiveShareViewController *shareController = [segue destinationViewController];
        [shareController setArchiveIdentifier:self.identifier];
        [shareController setArchiveTitle:[StringUtils stringFromObject:_doc.title]];
        [shareController setImage:_aSyncImage.image];
        
    }
    
    if([[segue identifier] isEqualToString:@"imageSegue"]){
        ArchiveImageViewController *ivc = [segue destinationViewController];
        [ivc setUrl:sharedPhotoFile.url];
        [ivc setArchvieTitle:[StringUtils stringFromObject:_doc.title]];
    
        
    }
    
    if([[segue identifier] isEqualToString:@"viewCollection"]){
        
        HomeCollectionViewController *collectionViewController = [segue destinationViewController];
        [collectionViewController setIdentifier:_identifier];
    }
    
    
    if([[segue identifier] isEqualToString:@"phoneDetails"]){
        ArchivePhoneExtraDetailsViewController *phoneDetails = [segue destinationViewController];
        [phoneDetails setWebContent:_doc.description];
        [phoneDetails setMetadata:[_doc.rawDoc objectForKey:@"metadata"]];
    }
    
   

}


#pragma mark - page view controller
/* Stupid, but works */

- (ArchiveBookPageImageViewController *) pageControllerForIndex:(int)index{
    
    NSLog(@"-----> pages.count: %i   index:%i", pages.count, index);
    
    ArchiveBookPageImageViewController *p0;
    ArchiveBookPageImageViewController *p1;
    
    ArchiveBookPageImageViewController *p2;

    ArchiveBookPageImageViewController *p3;
    ArchiveBookPageImageViewController *p4;
    
 
    
    
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
    if([pages objectAtIndex:3]){
        p3 = [pages objectAtIndex:3];
        NSLog(@"p3.index: %i", p3.index);
        
    }
    if([pages objectAtIndex:4]){
        p4 = [pages objectAtIndex:4];
        NSLog(@"p4.index: %i", p4.index);
        
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
    else if(p3.index == index){
        NSLog(@"--> 3 HIT");
        [self setPagesWithIndex:index];
        return p3;
    }
    else if(p4.index == index){
        NSLog(@"--> 4 HIT");
        [self setPagesWithIndex:index];
        return p4;
    }
    else {
        NSLog(@"--> go fish");
        [self setPagesWithIndex:index];
        return [pages objectAtIndex:2];
    }
    
    
}

- (void) setPagesWithIndex:(int)index{
    [pages setObject:[self newPageControllerWithIndex:index - 2] atIndexedSubscript:0];
    [pages setObject:[self newPageControllerWithIndex:index - 1] atIndexedSubscript:1];
    [pages setObject:[self newPageControllerWithIndex:index] atIndexedSubscript:2];
    [pages setObject:[self newPageControllerWithIndex:index + 1] atIndexedSubscript:3];
    [pages setObject:[self newPageControllerWithIndex:index + 2] atIndexedSubscript:4];

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
        ArchiveBookPageImageViewController *currentViewController = (ArchiveBookPageImageViewController*)[pages objectAtIndex:2];
        
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
        
        
        ArchiveBookPageImageViewController *currentViewController = (ArchiveBookPageImageViewController*)[pages objectAtIndex:2];
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
    
    [_spinner startAnimating];
 
    
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


- (void) loadAWebView:(UIWebView *)webView{
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", _doc.description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [webView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                  MIMEType:@"text/html"
          textEncodingName:@"UTF-8"
                   baseURL:theBaseURL];

}

- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    _doc = [[results objectForKey:@"documents"] objectAtIndex:0];
    _docTitle.text = [StringUtils stringFromObject:_doc.title];
    
    
    
    [self loadAWebView:_description];
    
    
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
    
    if([[metadata objectForKey:@"mediatype"] isEqualToString:@"collection"]){
        [_viewCollectionButton setEnabled:YES];
    }
    
    [_spinner stopAnimating];


}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        return NO;
    } else {
        return YES;
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

- (IBAction)openWebPage:(id)sender{
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://archive.org/details/%@", _identifier]];
    [[UIApplication sharedApplication] openURL:aUrl];

}


@end
