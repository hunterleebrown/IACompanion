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
#import "CentralViewController.h"
#import "FavoritesTableViewController.h"

@interface InitialViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)  MediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) CentralViewController *centralViewController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) UIStatusBarStyle statusBarStyle;

@end

@implementation InitialViewController
@synthesize mediaPlayerHolder, mediaPlayerViewController, managedObjectContext, loadingIndicatorHolder, loadingIndicatorViewController, centralViewController;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFavoritesNotification:) name:@"OpenFavorites" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBookViewControllerNotification:) name:@"OpenBookViewer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoadingIndicatorNotification:) name:@"ShowLoadingIndicator" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopUpControllerNotification:) name:@"NotifyUser" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFavoritesNotification:) name:@"AddFavoriteNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarWhite) name:@"ChangeStatusBarWhite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarBlack) name:@"ChangeStatusBarBlack" object:nil];



    
//    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
//        [self setNeedsStatusBarAppearanceUpdate];
//    }


    [self.mediaPlayerHolder setBackgroundColor:[UIColor clearColor]];

    self.statusBarStyle = UIStatusBarStyleDefault;

}

- (void)changeStatusBarWhite
{
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)changeStatusBarBlack
{
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
   return self.statusBarStyle;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"mediaPlayer"]){
        mediaPlayerViewController = [segue destinationViewController];
        [mediaPlayerViewController setManagedObjectContext:self.managedObjectContext];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    if([segue.identifier isEqualToString:@"loadingViewController"]){
        loadingIndicatorViewController = [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"centralViewController"]) {
        centralViewController = [segue destinationViewController];
    
    }


}

- (void) showPopUpControllerNotification:(NSNotification *)notification{
    PopUpViewController *popUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"popUpViewController"];
    [popUpVC setModalPresentationStyle:UIModalPresentationFormSheet];
    [popUpVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

    [popUpVC showWithSubView:nil title:@"Something went wrong" message:notification.object];
    [self presentViewController:popUpVC animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndRefreshing" object:nil];

    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [centralViewController toggleContent:nil];
}

- (void) showLoadingIndicatorNotification:(NSNotification *)notification{
   // [self.window bringSubviewToFront:loadingView];
    
    [loadingIndicatorHolder setHidden:![notification.object boolValue]];
    [self.view bringSubviewToFront:loadingIndicatorHolder];
    [loadingIndicatorViewController startAnimating:[notification.object boolValue]];
    
    
}


- (void) closePlayer{
    [self.centralViewHolder setHidden:NO];
    self.statusBarStyle = UIStatusBarStyleDefault;

    [UIView animateWithDuration:0.33 animations:^{
        //[mediaPlayerHolder setFrame:CGRectMake(- mediaPlayerHolder.frame.size.width, 0, mediaPlayerHolder.frame.size.width, mediaPlayerHolder.frame.size.height)];
        [mediaPlayerHolder setAlpha:0.0];
        [self.centralViewHolder setAlpha:1.0];
        [self setNeedsStatusBarAppearanceUpdate];

    } completion:^(BOOL finished) {
        [mediaPlayerHolder setHidden:YES];
    }];

}

- (void) openPlayer {
    [mediaPlayerHolder setHidden:NO];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [UIView animateWithDuration:0.33 animations:^{
        //[mediaPlayerHolder setFrame:CGRectMake(0, 0, mediaPlayerHolder.frame.size.width, mediaPlayerHolder.frame.size.height)];
        [mediaPlayerHolder setAlpha:1.0];
        [self.centralViewHolder setAlpha:0.0];
        [self setNeedsStatusBarAppearanceUpdate];

    } completion:^(BOOL finished) {
        [self.centralViewHolder setHidden:YES];
    }];
}






- (void) openFavoritesNotification:(NSNotification *)notification {
    ArchiveSearchDoc *doc = notification.object;
    
    UINavigationController *favoritesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"favoritesVC"];
    [favoritesVC setModalPresentationStyle:UIModalPresentationFormSheet];
    [favoritesVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    FavoritesTableViewController *favs = (FavoritesTableViewController *)[favoritesVC.viewControllers objectAtIndex:0];

    [favs setManagedObjectContext:self.managedObjectContext];
    
    [self presentViewController:favoritesVC animated:YES completion:^{
        if(doc){
            [favs addFavorite:doc];
        }
    }];

}










- (void) showBookViewControllerNotification:(NSNotification *)notification{
    ArchivePageViewController *bookViewControllers = notification.object;
    [bookViewControllers setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
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
