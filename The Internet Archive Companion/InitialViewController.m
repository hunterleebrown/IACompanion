//
//  RootViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "InitialViewController.h"
#import "MediaPlayerViewController.h"

@interface InitialViewController ()

@property (nonatomic, strong)  MediaPlayerViewController *mediaPlayerViewController;

@end

@implementation InitialViewController
@synthesize mediaPlayerHolder, mediaPlayerViewController, managedObjectContext;

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
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"mediaPlayer"]){
        
        mediaPlayerViewController = [segue destinationViewController];
        [mediaPlayerViewController setManagedObjectContext:self.managedObjectContext];
        
    }

}


- (void) closePlayer{
    [UIView animateWithDuration:0.33 animations:^{
        [mediaPlayerHolder setFrame:CGRectMake(-320, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];

}

- (void) openPlayer {
    [UIView animateWithDuration:0.33 animations:^{
        [mediaPlayerHolder setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
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
