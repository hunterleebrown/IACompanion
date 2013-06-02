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
    
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView setShowsVerticalScrollIndicator:YES];
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    //set the zooming properties of the scroll view
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 10.0;
    
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



- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"GOT A ZOOM");
    
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"GOT A ZOOM DID END");
    
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    
    
}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}





@end
