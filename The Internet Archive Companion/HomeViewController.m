//
//  ViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeViewController.h"
#import "ArchiveDataService.h"
#import "ArchiveDetailedCollectionViewController.h"
#import "ArchiveSearchDoc.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.audioCollection getCollectionWithName:@"audio"];
    [self.videoCollection getCollectionWithName:@"movies"];
    [self.textCollection getCollectionWithName:@"texts"];
    [self setTitle:@"Top Level Collections"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    ArchiveSearchDoc *doc;
    MediaType type;
    
    if ([[segue identifier] isEqualToString:@"audioCellPush"])
    {
        NSIndexPath *selectedIndexPath = [[self.audioCollection indexPathsForSelectedItems] objectAtIndex:0];
        doc = [self.audioCollection.docs objectAtIndex:selectedIndexPath.row];
        type = MediaTypeAudio;
    }
    else if ([[segue identifier] isEqualToString:@"videoCellPush"])
    {
        NSIndexPath *selectedIndexPath = [[self.videoCollection indexPathsForSelectedItems] objectAtIndex:0];
        doc = [self.videoCollection.docs objectAtIndex:selectedIndexPath.row];
        type = MediaTypeVideo;
    }
    else {
        NSIndexPath *selectedIndexPath = [[self.textCollection indexPathsForSelectedItems] objectAtIndex:0];
        doc = [self.textCollection.docs objectAtIndex:selectedIndexPath.row];
        type = MediaTypeTexts;
    }
    
    

    ArchiveDetailedCollectionViewController *detailCollectionViewController = [segue destinationViewController];
    [detailCollectionViewController setCollectionIdentifier:doc.identifier forType:type];
    [detailCollectionViewController setTitle:doc.title];


}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Before we navigate away from this view (the back button was pressed)
    // remove the edit popover (if it exists).
}


@end
