//
//  ItemContentViewController.m
//  IA
//
//  Created by Hunter on 6/30/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ItemContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ArchiveLoadingView.h"
#import "ArchiveFile.h"

@interface ItemContentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet ArchiveLoadingView *loadingIndicator;
@property (nonatomic, strong) NSMutableArray *mediaFiles;
@property (nonatomic, strong) NSMutableDictionary *organizedMediaFiles;
@property (nonatomic, weak) IBOutlet UITableView *mediaTable;

@end

@implementation ItemContentViewController
@synthesize loadingIndicator, mediaFiles, organizedMediaFiles, mediaTable;

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
    
    [self.navigationItem setLeftBarButtonItems:@[self.listButton, self.backButton]];
    [self.service fetchData];
    
    
    self.archiveDescription = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.archiveDescription.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.archiveDescription setBackgroundColor:[UIColor clearColor]];
    [self.archiveDescription setOpaque:NO];
    [loadingIndicator startAnimating];
    
    mediaFiles = [NSMutableArray new];
    organizedMediaFiles = [NSMutableDictionary new];

}

- (void) dataDidBecomeAvailableForService:(IADataService *)service{
    
    //ArchiveDetailDoc *doc = ((IAJsonDataService *)service).rawResults
    assert([[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0] != nil);
    self.detDoc = [[((IAJsonDataService *)service).rawResults objectForKey:@"documents"] objectAtIndex:0];
    
    self.titleLabel.text = self.detDoc.title;
    if(self.detDoc.archiveImage){
        [self.imageView setArchiveImage:self.detDoc.archiveImage];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 88, self.tableHeaderView.frame.size.width, self.tableHeaderView.frame.size.height - 122);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.tableHeaderView.layer insertSublayer:gradient atIndex:1];
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#FAEBD7; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", self.detDoc.description];
    
    [self setTitle:self.detDoc.title];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16], UITextAttributeFont, nil]];
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    
    
    [self.archiveDescription loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                             MIMEType:@"text/html"
                     textEncodingName:@"UTF-8"
                              baseURL:theBaseURL];
    
    [loadingIndicator stopAnimating];

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
    
}

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

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(organizedMediaFiles.count == 0){
        return @"";
    }
    
    ArchiveFile *firstFile;
    firstFile = [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:section]] objectAtIndex:0];
    return [firstFile.file objectForKey:@"format"];
  
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaFileCell"];
    
    if(organizedMediaFiles.count > 0){
        ArchiveFile *aFile = [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.textLabel.text = aFile.title;
    }
    
    
    return cell;

}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(organizedMediaFiles.count == 0){
        return 0;
    }
    
    return [[organizedMediaFiles objectForKey:[[organizedMediaFiles allKeys]  objectAtIndex:section]] count];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
