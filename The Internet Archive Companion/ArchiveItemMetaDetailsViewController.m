//
//  ArchiveItemMetaDetailsViewController.m
//  IA
//
//  Created by Hunter on 5/19/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveItemMetaDetailsViewController.h"

@interface ArchiveItemMetaDetailsViewController ()

@end

@implementation ArchiveItemMetaDetailsViewController

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
}

- (void) viewDidAppear:(BOOL)animated{
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:_metaData];
    [_metadataTableView setMetadata:mut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
