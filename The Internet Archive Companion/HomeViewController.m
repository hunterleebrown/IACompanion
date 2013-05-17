//
//  HomeViewController.m
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
    
    
    }
    return self;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"contentController"]){
        _contentController = [segue destinationViewController];
    
    } else if([[segue identifier] isEqualToString:@"playerController"]){
        _playerController = [segue destinationViewController];
    } else if([[segue identifier] isEqualToString:@"favoritesController"]){
        _favoritesController = [segue destinationViewController];
    }

}



- (void) unHidePlayer{
    [UIView animateWithDuration:0.33 animations:^{
        _top.frame = CGRectMake(_top.frame.origin.x, _top.frame.origin.y, _top.frame.size.width, self.view.bounds.size.height - _bottom.frame.size.height);
        _bottom.frame = CGRectMake(_bottom.frame.origin.x,  _top.frame.size.height, _bottom.frame.size.width, _bottom.frame.size.height);
        _shadow.frame = CGRectMake(_shadow.frame.origin.x, _bottom.frame.origin.y - 19, _shadow.frame.size.width, _shadow.frame.size.height);
        if(_animatedLabel){
            _animatedLabel.frame = CGRectMake(_animatedLabel.frame.origin.x, 200, _animatedLabel.frame.size.width, _animatedLabel.frame.size.height);
        }
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
            _playerController.upupButton.transform = transform;
        } completion:NULL];
    }];

    


}


- (void)hidePlayer{
    if(_bottom.frame.origin.y == (self.view.bounds.size.height - 44)){
        // reveal
        [self unHidePlayer];
        
    } else {
        // hide
        [UIView animateWithDuration:0.33 animations:^{
           
           _top.frame = CGRectMake(_top.frame.origin.x, _top.frame.origin.y, _top.frame.size.width, self.view.bounds.size.height - 44);
           _bottom.frame = CGRectMake(_bottom.frame.origin.x, self.view.bounds.size.height - 44, _bottom.frame.size.width, _bottom.frame.size.height);
           _shadow.frame = CGRectMake(_shadow.frame.origin.x, _bottom.frame.origin.y - 19, _shadow.frame.size.width, _shadow.frame.size.height);
           if(_animatedLabel){
               _animatedLabel.frame = CGRectMake(_animatedLabel.frame.origin.x, self.view.bounds.size.height - 66, _animatedLabel.frame.size.width, _animatedLabel.frame.size.height);
           }

       } completion:^(BOOL finished) {
           [UIView beginAnimations:@"rotate" context:nil];
           [UIView setAnimationDuration:0.3];
           _playerController.upupButton.transform = CGAffineTransformMakeRotation(90/180*M_PI);
           [UIView commitAnimations];


       }];

    }

    


}


- (void) showPlayerDrawer{

    [UIView animateWithDuration:0.33 animations:^{
        [_bottom setFrame:CGRectMake(self.view.bounds.size.width - 768, _bottom.frame.origin.y, 768, _bottom.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];

}

- (void) hidePlayerDrawer{
    [UIView animateWithDuration:0.33 animations:^{
        [_bottom setFrame:CGRectMake(self.view.bounds.size.width - 22, _bottom.frame.origin.y, 768, _bottom.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];

}


- (IBAction)togglerPlayer:(id)sender {
    if(_bottom.frame.origin.x == self.view.bounds.size.width - 768){
        [self hidePlayerDrawer];
        
    } else {
        [self showPlayerDrawer];
        
    }
    
}


- (void) toggleFavorites{
    if(_favorites.frame.origin.x == self.view.bounds.size.width - 320){
        [UIView animateWithDuration:0.33 animations:^{
            [_favorites setFrame:CGRectMake(self.view.bounds.size.width - 22, _favorites.frame.origin.y, 320, 300)];
        } completion:^(BOOL finished) {
            
        }];

    
    } else {
        [UIView animateWithDuration:0.33 animations:^{
            [_favorites setFrame:CGRectMake(self.view.bounds.size.width - 320, _favorites.frame.origin.y, 320, 300)];
        } completion:^(BOOL finished) {
            
        }];
        
        
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTextToLabel:) name:@"AddPlayingFileName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePlayerDrawer) name:@"HidePlayerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlayerDrawer) name:@"UnHidePlayerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleFavorites) name:@"ToggleFavoritesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(togglerPlayer:) name:@"TogglePlayerNotification" object:nil];

    

    
    
    [_playerController setManagedObjectContext:self.managedObjectContext];

}

- (void) addTextToLabel:(NSNotification *)notification{
    _animatedLabel.text = notification.object;

}

- (void) animateTheLabel{
    [UIView animateWithDuration:8.0 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat animations:^{
        _animatedLabel.frame = CGRectMake(- _animatedLabel.frame.size.width, _animatedLabel.frame.origin.y, _animatedLabel.frame.size.width, _animatedLabel.frame.size.height);
    } completion:^(BOOL finished) {
        _animatedLabel.frame = CGRectMake(320, _animatedLabel.frame.origin.y, _animatedLabel.frame.size.width, _animatedLabel.frame.size.height);
        
        //[self animateTheLabel];
    }];
    
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
