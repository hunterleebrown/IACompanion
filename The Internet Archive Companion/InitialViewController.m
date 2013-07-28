//
//  RootViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "InitialViewController.h"
#import "MediaPlayerViewController.h"
#import "ArchivePageViewController.h"
#import "LoadingViewController.h"

@interface InitialViewController ()

@property (nonatomic, strong)  MediaPlayerViewController *mediaPlayerViewController;

@end

@implementation InitialViewController
@synthesize mediaPlayerHolder, mediaPlayerViewController, managedObjectContext, loadingIndicatorHolder, loadingIndicatorViewController;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlayer) name:@"CloseMediaPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPlayer) name:@"OpenMediaPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBookViewControllerNotification:) name:@"OpenBookViewer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoadingIndicatorNotification:) name:@"ShowLoadingIndicator" object:nil];
   
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"mediaPlayer"]){
        mediaPlayerViewController = [segue destinationViewController];
        [mediaPlayerViewController setManagedObjectContext:self.managedObjectContext];
    }
    if([segue.identifier isEqualToString:@"loadingViewController"]){
        loadingIndicatorViewController = [segue destinationViewController];
    }
    

}

- (void) showLoadingIndicatorNotification:(NSNotification *)notification{
   // [self.window bringSubviewToFront:loadingView];
    
    [loadingIndicatorHolder setHidden:![notification.object boolValue]];
    [self.view bringSubviewToFront:loadingIndicatorHolder];
    [loadingIndicatorViewController startAnimating:[notification.object boolValue]];
    
    
}


- (void) closePlayer{
    [UIView animateWithDuration:0.33 animations:^{
        [mediaPlayerHolder setFrame:CGRectMake(- mediaPlayerHolder.frame.size.width, 0, mediaPlayerHolder.frame.size.width, mediaPlayerHolder.frame.size.height)];
    }];

}

- (void) openPlayer {
    [UIView animateWithDuration:0.33 animations:^{
        [mediaPlayerHolder setFrame:CGRectMake(0, 0, mediaPlayerHolder.frame.size.width, mediaPlayerHolder.frame.size.height)];
    }];
}


- (void) showBookViewControllerNotification:(NSNotification *)notification{
    ArchivePageViewController *bookViewControllers = notification.object;
    [bookViewControllers setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:bookViewControllers animated:YES completion:nil];

}



- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
