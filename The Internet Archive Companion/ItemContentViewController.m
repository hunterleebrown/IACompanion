//
//  ItemContentViewController.m
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ItemContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ArchiveFile.h"
#import "MediaFileCell.h"
#import "MediaFileHeaderCell.h"
#import "MediaImageViewController.h"
#import "ArchivePageViewController.h"
#import <Social/Social.h>
#import "MediaUtils.h"


@interface ItemContentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *mediaFiles;
@property (nonatomic, strong) NSMutableDictionary *organizedMediaFiles;
@property (nonatomic, weak) IBOutlet UITableView *mediaTable;

@property (nonatomic, weak) IBOutlet UIButton *favoritesButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;



@end

@implementation ItemContentViewController
@synthesize mediaFiles, organizedMediaFiles, mediaTable;

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
    
    [self.navigationItem setLeftBarButtonItems:@[self.backButton, self.listButton, self.mpBarButton]];
    [self.service fetchData];
    
    
    self.archiveDescription = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.archiveDescription.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.archiveDescription setBackgroundColor:[UIColor clearColor]];
    [self.archiveDescription setOpaque:NO];
    [self.archiveDescription setDelegate:self];
    
    mediaFiles = [NSMutableArray new];
    organizedMediaFiles = [NSMutableDictionary new];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];

    if ([self.mediaTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mediaTable setSeparatorInset:UIEdgeInsetsZero];
    }





}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [gradient setStartPoint:CGPointMake(0.0, 0.5)];
//        [gradient setEndPoint:CGPointMake(1.0, 0.5)];
//        gradient.frame = CGRectMake(0,0, self.tableHeaderView.bounds.size.width, self.tableHeaderView.bounds.size.height);
//
//    } else {
//        gradient.frame = CGRectMake(0, self.descriptionButton.frame.origin.y, self.tableHeaderView.bounds.size.width, self.descriptionButton.bounds.size.height);
//    }
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//    [self.tableHeaderView.layer insertSublayer:gradient atIndex:1];
//
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        CAGradientLayer *gradient2 = [CAGradientLayer layer];
//        gradient2.frame = CGRectMake(0, 0, self.tableHeaderView.bounds.size.width, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height);
//        gradient2.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
//        [self.tableHeaderView.layer insertSublayer:gradient2 atIndex:1];
//
//    }

    
}

#pragma mark - Results

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    //ArchiveDetailDoc *doc = ((IAJsonDataService *)service).rawResults
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    self.detDoc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    self.titleLabel.text = self.detDoc.title;
    if(self.detDoc.archiveImage){
        [self.imageView setArchiveImage:self.detDoc.archiveImage];
    }
    
    self.typeLabel.text = [MediaUtils iconStringFromMediaType:self.detDoc.type];
    [self.typeLabel setTextColor:[MediaUtils colorFromMediaType:self.detDoc.type]];


//    [self.tableHeaderView setBackgroundColor:[MediaUtils colorFromMediaType:self.detDoc.type]];

    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#ffffff; color:#000; font-size:14px; font-family:\"Helvetica\"'>%@</body></html>", self.detDoc.details];
    
//    [self setTitle:self.detDoc.title];

    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16], NSFontAttributeName, nil]];

    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    
    
    [self.archiveDescription loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                             MIMEType:@"text/html"
                     textEncodingName:@"UTF-8"
                              baseURL:theBaseURL];
    

    [self.metaDataTable addMetadata:[self.detDoc.rawDoc objectForKey:@"metadata"]];
    
    NSMutableArray *files = [NSMutableArray new];
    for(ArchiveFile *file in self.detDoc.files){
        if(file.format != FileFormatOther){
            [files addObject:file];
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"track" ascending:YES];
    [mediaFiles addObjectsFromArray:[files sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
    
    [self orgainizeMediaFiles:mediaFiles];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];

    
}

#pragma mark -

- (void) orgainizeMediaFiles:(NSMutableArray *)files{
    for(ArchiveFile *f in files){
        if([organizedMediaFiles objectForKey:[NSNumber numberWithInt:f.format]] != nil){
            [[organizedMediaFiles objectForKey:[NSNumber numberWithInt:f.format]] addObject:f];
        } else {
            NSMutableArray *filesForFormat = [NSMutableArray new];
            [filesForFormat addObject:f];
            [organizedMediaFiles setObject:filesForFormat forKey:[NSNumber numberWithInt:f.format]];
        }
    }
    
    [mediaTable reloadData];
    
}

#pragma mark - Table Stuff
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(organizedMediaFiles.count == 0){
        return @"";
    }
    
    ArchiveFile *firstFile;
    firstFile = [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:section]] objectAtIndex:0];
    return [firstFile.file objectForKey:@"format"];
  
} 

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaFileCell"];
    
    if(organizedMediaFiles.count > 0){
        ArchiveFile *aFile = [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.fileTitle.text = aFile.title;
        cell.fileFormat.text = [aFile.file objectForKey:@"format"];
        cell.fileName.text = aFile.name;
        
    }
    
    
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(organizedMediaFiles.count > 0){
        ArchiveFile *aFile = [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        if(aFile.format == FileFormatJPEG || aFile.format == FileFormatGIF) {
            MediaImageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mediaImageViewController"];
            [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            ArchiveImage *image = [[ArchiveImage alloc] initWithUrlPath:aFile.url];
            [vc setImage:image];
            [self presentViewController:vc animated:YES completion:nil];
        } else if (aFile.format == FileFormatDjVuTXT || aFile.format == FileFormatProcessedJP2ZIP || aFile.format == FileFormatTxt) {
            ArchivePageViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"archivePageViewController"];
            [pageViewController setIdentifier:self.searchDoc.identifier];
            [pageViewController setBookFile:aFile];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenBookViewer" object:pageViewController];


        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToPlayerListFileAndPlayNotification" object:aFile];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
        }
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MediaFileHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"mediaFileHeaderCell"];

    if(organizedMediaFiles.count > 0){
        ArchiveFile *firstFile;
        firstFile = [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:section]] objectAtIndex:0];
        headerCell.sectionHeaderLabel.text = [firstFile.file objectForKey:@"format"];
        [headerCell setTypeLabelIconFromFileTypeString:[firstFile.file objectForKey:@"format"]];
    }
    return headerCell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return organizedMediaFiles.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(organizedMediaFiles.count == 0){
        return 0;
    }

    return [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:section]] count];
}


#pragma mark -


- (IBAction)playAll:(id)sender
{
    
    for(ArchiveFile *aFile in mediaFiles) {
        if(aFile.format == FileFormatJPEG || aFile.format == FileFormatGIF)
        {
            
        }
        else if (aFile.format == FileFormatDjVuTXT || aFile.format == FileFormatProcessedJP2ZIP || aFile.format == FileFormatTxt)
        {
            
        } else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToPlayerListFileNotification" object:aFile];
        }
    }

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenMediaPlayer" object:nil];
}






- (IBAction)addFavorite:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFavoriteNotification" object:self.searchDoc];


}


- (IBAction)showSharingActionsSheet:(id)sender{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://archive.org/details/%@", self.detDoc.identifier]];
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    if([shareViewController respondsToSelector:@selector(popoverPresentationController)]){
        [shareViewController.popoverPresentationController setSourceView:sender];
    }
    [self presentViewController:shareViewController animated:YES completion:nil];
    
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 || buttonIndex == 1) {
        
        NSString *serviceType = buttonIndex == 0 ? SLServiceTypeFacebook : SLServiceTypeTwitter;
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        NSString *archiveUrl = [NSString stringWithFormat:@"http://archive.org/details/%@", self.detDoc.identifier];
        [controller addURL:[NSURL URLWithString:archiveUrl]];
  //      [controller setInitialText:[NSString stringWithFormat:@"Internet Archive - %@", self.detDoc.title]];
        

        [self presentViewController:controller animated:YES completion:nil];
        
    }  else if (buttonIndex == 2) {
        
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:self.detDoc.title];
            [mailViewController setMessageBody:[self shareMessage] isHTML:YES];
            [self presentViewController:mailViewController animated:YES completion:nil];
        } else {
            [self displayUnableToSendEmailMessage];
        }
    }
    
}

- (void)displayEmailSentMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent"
                                                    message:@"Your message was successfully sent."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:( MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            //  NSLog(@"Message Canceled");
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Message Saved");
            break;
        case MFMailComposeResultSent:
            [self displayEmailSentMessage];
            break;
        case MFMailComposeResultFailed:
            [self displayUnableToSendEmailMessage];
            break;
        default:
            //  NSLog(@"Message Not Sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)displayUnableToSendEmailMessage {
    NSString *errorMessage = @"The device is unable to send email in its current state.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Send Email"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (NSString *)shareMessage{
    
    return [NSString stringWithFormat:@"From the Internet Archive: %@", [NSString stringWithFormat:@"http://archive.org/details/%@", self.detDoc.identifier]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
