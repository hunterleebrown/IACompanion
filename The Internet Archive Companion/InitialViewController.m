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
#import "NotifyUserView.h"
#import "FontMapping.h"

@interface InitialViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)  MediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) CentralViewController *centralViewController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) UIStatusBarStyle statusBarStyle;

@property (nonatomic, weak) IBOutlet NotifyUserView *notifyUserView;

@property (nonatomic) IBOutlet NSLayoutConstraint *mediaPlayerTopConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *mediaPlayerHeightConstraint;

@end

@implementation InitialViewController

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMediaPlayer) name:@"ToggleMediaPlayer" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlayer) name:@"CloseMediaPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPlayer) name:@"OpenMediaPlayer" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFavoritesNotification:) name:@"OpenFavorites" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBookViewControllerNotification:) name:@"OpenBookViewer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoadingIndicatorNotification:) name:@"ShowLoadingIndicator" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopUpControllerNotification:) name:@"NotifyUser" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFavoritesNotification:) name:@"AddFavoriteNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarWhite) name:@"ChangeStatusBarWhite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarBlack) name:@"ChangeStatusBarBlack" object:nil];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCredits) name:@"OpenCredits" object:nil];

    

    
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
        [self setNeedsStatusBarAppearanceUpdate];
    }


    self.statusBarStyle = UIStatusBarStyleDefault;


    
    self.mediaPlayerTopConstraint.constant = self.view.bounds.size.height - 64;
    self.mediaPlayerHeightConstraint.constant = self.view.bounds.size.height;
    
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
        self.mediaPlayerViewController = [segue destinationViewController];
        [self.mediaPlayerViewController setManagedObjectContext:self.managedObjectContext];
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
    if([segue.identifier isEqualToString:@"loadingViewController"]){
        self.loadingIndicatorViewController = [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"centralViewController"]) {
        self.centralViewController = [segue destinationViewController];
    
    }


}

- (void) showPopUpControllerNotification:(NSNotification *)notification{
//    PopUpViewController *popUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"popUpViewController"];
  //  [popUpVC setModalPresentationStyle:UIModalPresentationFormSheet];
   // [popUpVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

//    [popUpVC showWithSubView:nil title:@"Something went wrong" message:notification.object];
 //   [self presentViewController:popUpVC animated:YES completion:nil];


    self.notifyUserView.message.text = notification.object;
    [self.notifyUserView show];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndRefreshing" object:nil];

    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [centralViewController toggleContent:nil];
}

- (void) showLoadingIndicatorNotification:(NSNotification *)notification{
   // [self.window bringSubviewToFront:loadingView];
    
//    [loadingIndicatorHolder setHidden:![notification.object boolValue]];
//    [self.view bringSubviewToFront:loadingIndicatorHolder];
//    [loadingIndicatorViewController startAnimating:[notification.object boolValue]];
//    

}


- (void)toggleMediaPlayer
{
    if(self.mediaPlayerTopConstraint.constant == 0)
    {
        [self closePlayer];
    }
    else
    {
        [self openPlayer];
    }

}

- (IBAction)panPlayer:(UIPanGestureRecognizer *)recognizer
{
    
    CGPoint point = [recognizer translationInView:self.view];
    CGFloat newY = self.mediaPlayerTopConstraint.constant + point.y;
    if(newY >= 0 && newY < self.view.bounds.size.height - 64)
    {
        self.mediaPlayerTopConstraint.constant = newY;
        [self.mediaPlayerHolder layoutIfNeeded];
//        NSLog(@"PAN GESTURE RECOGNIZER ----->:%f", [recognizer velocityInView:self.view].y);
        CGFloat yVelocity = [recognizer velocityInView:self.view].y;
        if(yVelocity > 1000)
        {
            [self closePlayer];
        }
        
        if(yVelocity < -1000)
        {
            [self openPlayer];
        }
        
    }
    // THIS Was the magic sauce. W/O it all mayhem breaks lose.
    [recognizer setTranslation:CGPointZero inView:self.view];

}


- (IBAction) closePlayer{
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.33 animations:^{

        self.mediaPlayerTopConstraint.constant = self.view.bounds.size.height - 64;
        self.mediaPlayerHeightConstraint.constant = self.view.bounds.size.height;
        
        [self.mediaPlayerHolder layoutIfNeeded];
        [self.view layoutIfNeeded];

        [self setNeedsStatusBarAppearanceUpdate];

    } completion:^(BOOL finished) {
//        [self.mediaPlayerHolder setHidden:NO];
    }];

}

- (IBAction) openPlayer {
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self.view layoutIfNeeded];

    
    [UIView animateWithDuration:0.33 animations:^{
        self.mediaPlayerTopConstraint.constant = 0;
        self.mediaPlayerHeightConstraint.constant = self.view.bounds.size.height;
        
        [self.mediaPlayerHolder layoutIfNeeded];
        [self.view layoutIfNeeded];
        [self setNeedsStatusBarAppearanceUpdate];
        
    } completion:^(BOOL finished) {
//        [self.centralViewHolder setHidden:NO];
    }];
}


- (void)openCredits
{
    UINavigationController *creditsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"creditsViewController"];
    [self presentViewController:creditsVC animated:YES completion:nil];

}



- (void) openFavoritesNotification:(NSNotification *)notification {
    ArchiveSearchDoc *doc = notification.object;
    
    UINavigationController *favoritesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"favoritesVC"];
    [favoritesVC setModalPresentationStyle:UIModalPresentationFormSheet];
//    [favoritesVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    FavoritesTableViewController *favs = (FavoritesTableViewController *)[favoritesVC.viewControllers objectAtIndex:0];

    [favs setManagedObjectContext:self.managedObjectContext];


    if(!doc) {
        [self presentViewController:favoritesVC animated:YES completion:nil];
    } else {
        [favs addFavorite:doc];
    }


}





- (void) dealloc
{

    
    NSArray *notifications = @[@"ToggleMediaPlayer",
                               @"CloseMediaPlayer",
                               @"OpenMediaPlayer",
                               @"OpenFavorites",
                               @"OpenBookViewer",
                               @"ShowLoadingIndicator",
                               @"NotifyUser",
                               @"AddFavoriteNotification",
                               @"ChangeStatusBarWhite",
                               @"ChangeStatusBarBlack",
                               @"OpenCredits"];
    
    for(NSString *notification in notifications)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notification object:nil];
    }
    
    
    
}




- (void) showBookViewControllerNotification:(NSNotification *)notification{
    ArchivePageViewController *bookViewControllers = notification.object;
    [bookViewControllers setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:bookViewControllers animated:YES completion:nil];

}



- (BOOL) shouldAutorotate {
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        return YES;
//    }
    return YES;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
