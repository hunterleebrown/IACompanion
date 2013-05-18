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
        [shareController setArchiveIdentifier:_archiveIdentifier];
        [shareController setArchiveTitle:[StringUtils stringFromObject:_archvieTitle]];
        [shareController setImage:_imageView.image];
        
        
    }
}

- (IBAction)dismiss:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewWillAppear:(BOOL)animated{
    //[self.navigationController setNavigationBarHidden:YES];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    //[self.navigationController setNavigationBarHidden:NO];    // it shows
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void) viewDidAppear:(BOOL)animated  {
    [self.imageView setAndLoadImageFromUrl:_url];

}


- (void) setUrl:(NSString *)url{
    _url = url;

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
