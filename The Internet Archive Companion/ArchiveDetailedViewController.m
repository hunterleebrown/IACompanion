//
//  ArchiveDetailedViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/31/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDetailedViewController.h"

@interface ArchiveDetailedViewController ()

@end

@implementation ArchiveDetailedViewController



- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        
        service = [ArchiveDataService new];
        [service setDelegate:self];
        
    }
    return self;
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
