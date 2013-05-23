//
//  ArchiveCollectionDetailedViewController.m
//  IA
//
//  Created by Hunter on 5/22/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveCollectionDetailedViewController.h"

@interface ArchiveCollectionDetailedViewController ()

@end

@implementation ArchiveCollectionDetailedViewController

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSegueWithNotification:) name:@"CollectionCellNotification" object:nil];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doSegueWithNotification:(NSNotification *)notification{
    ArchiveSearchDoc *aDoc = [notification object];
    
    if(aDoc.type == MediaTypeCollection){
        [self performSegueWithIdentifier:@"collectionCellCollectionPush" sender:aDoc];
    } else {
        [self performSegueWithIdentifier:@"collectionCellDetailPush" sender:aDoc];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];

    if([[segue identifier] isEqualToString:@"collectionViewController"]){
        _collectionListViewController = [segue destinationViewController];
        [_collectionListViewController setIdentifier:self.identifier];
        
    }
    
    

    if([[segue identifier] isEqualToString:@"collectionCellDetailPush"]){
        ArchiveSearchDoc *aDoc = (ArchiveSearchDoc *)sender;
        ArchiveDetailedViewController *advc= [segue destinationViewController];
        [advc setIdentifier:aDoc.identifier];
    }

    if([[segue identifier] isEqualToString:@"collectionCellCollectionPush"]){
        ArchiveSearchDoc *aDoc = (ArchiveSearchDoc *)sender;
        ArchiveCollectionDetailedViewController *advc= [segue destinationViewController];
        [advc setIdentifier:aDoc.identifier];
    }

}


@end
