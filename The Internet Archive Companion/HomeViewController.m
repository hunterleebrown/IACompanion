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
    
    }

}


- (void)hidePlayer{
  /*  if(_bottom.frame.origin.y > self.view.bounds.size.height){
        // reveal
    
        [UIView animateWithDuration:0.33 animations:^{
            _top.frame = CGRectMake(_top.frame.origin.x, _top.frame.origin.y, _top.frame.size.width, _top.frame.size.height - 144);
            _bottom.frame = CGRectMake(_bottom.frame.origin.x, _top.frame.size.height, _bottom.frame.size.width, _bottom.frame.size.height);
        }];
        
    } else {
        // hide
        _top.frame = CGRectMake(_top.frame.origin.x, _top.frame.origin.y, _top.frame.size.width, _top.frame.size.height + 144);
        _bottom.frame = CGRectMake(_bottom.frame.origin.x, _top.frame.size.height, _bottom.frame.size.width, _bottom.frame.size.height);


    }
*/

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePlayer) name:@"HidePlayerNotification" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
