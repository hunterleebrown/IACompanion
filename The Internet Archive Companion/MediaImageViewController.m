//
//  MediaImageViewController.m
//  IA
//
//  Created by Hunter Brown on 7/20/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MediaImageViewController.h"
#import "FontMapping.h"

@interface MediaImageViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation MediaImageViewController
@synthesize closeButton, archiveImageView, scrollView, image;

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
    [scrollView setZoomScale:1.0];
    [scrollView setMaximumZoomScale:6.0];
    [scrollView setMinimumZoomScale:1.0];

    archiveImageView = [[ArchiveImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView addSubview:archiveImageView];
    [archiveImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [archiveImageView setArchiveImage:image];

    [self.closeButton setTitle:CLOSE forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(ArchiveImage *)im{
    image = im;
}

- (IBAction) didPressCloseButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotATap:(id)sender
{
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[archiveImageView.image] applicationActivities:nil];
    if([shareViewController respondsToSelector:@selector(popoverPresentationController)]){
        [shareViewController.popoverPresentationController setSourceView:self.view];
    }
    [self presentViewController:shareViewController animated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return archiveImageView;
}




@end
