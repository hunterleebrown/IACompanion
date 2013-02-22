//
//  ArchiveImageViewController.m
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveImageViewController.h"
#import "ArchiveShareViewController.h"
#import "StringUtils.h"


@interface ArchiveImageViewController ()

@end

@implementation ArchiveImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"shareImage"]){
        ArchiveShareViewController *shareController = [segue destinationViewController];
    
        UIPopoverController *pop = ((UIStoryboardPopoverSegue *)segue).popoverController;
        [shareController setMyPopOverController:pop];
       // [shareController setImage:((AsyncImageView *)_view).image];
        [shareController setArchiveTitle:_archvieTitle];
        
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void) setUrl:(NSString *)url{
    _url = url;
    [self.view setAndLoadImageFromUrl:_url];
    [self setTitle:_url];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}

@end
