//
//  HomeCombinedViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeCombinedViewController.h"

@interface HomeCombinedViewController () {

}




@end

@implementation HomeCombinedViewController

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



    
    
    [self doOrientationLayout:self.interfaceOrientation];

    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self doOrientationLayout:toInterfaceOrientation];

}




- (void) doOrientationLayout:(UIInterfaceOrientation)toInterfaceOrientation{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        [self.contentScrollView setContentSize:CGSizeMake(1024, 10)];
        
    } else {
        [self.contentScrollView setContentSize:CGSizeMake(1024, 10)];
        
    }
    

    
}
 




@end
