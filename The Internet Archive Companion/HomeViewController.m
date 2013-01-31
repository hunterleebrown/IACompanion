//
//  ViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeViewController.h"
#import "ArchiveDataService.h"
#import "ArchiveDetailedCollectionTableViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize audioCollection, videoCollection, textCollection;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [audioCollection getCollectionWithName:@"audio"];
    [videoCollection getCollectionWithName:@"movies"];
    [textCollection getCollectionWithName:@"texts"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"audioCellPush"])
    {
        NSIndexPath *selectedIndexPath = [[audioCollection indexPathsForSelectedItems] objectAtIndex:0];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'

        
        ArchiveDetailedCollectionTableViewController *detailViewController = [segue destinationViewController];
       // detailViewController.image = image;
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Before we navigate away from this view (the back button was pressed)
    // remove the edit popover (if it exists).
}


@end
