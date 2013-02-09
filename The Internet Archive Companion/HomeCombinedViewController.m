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
	// Do any additional setup after loading the view.
    
   // self.contentTableView = [[HomeContentTableView alloc] initWithFrame:CGRectMake(self.mainNavigationTable.frame.size.width, 0, 768, self.view.frame.size.height) style:UITableViewStylePlain];
    
    
    

    
   [self doOrientationLayout:self.interfaceOrientation];
    
   // [self.contentTableView setFrame:CGRectMake(256, 0, 768, self.view.bounds.size.height)];

    
    [self.contentTableView getCollection:@"movies"];
    
    
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
        [self.contentScrollView setFrame:CGRectMake(self.mainNavigationTable.frame.size.width, 0, 768, self.view.bounds.size.height)];
        [self.contentScrollView setContentSize:CGSizeMake(768, self.view.bounds.size.height)];
        
        [self.contentTableView setFrame:CGRectMake(0, 0, 768, self.contentScrollView.bounds.size.height)];
    } else {
        [self.contentScrollView setFrame:CGRectMake(0, 0, 768, self.view.bounds.size.height)];
        [self.contentScrollView setContentSize:CGSizeMake(1024, self.contentScrollView.bounds.size.height)];
        
        [self.contentTableView setFrame:CGRectMake(256, 0, 768, self.contentScrollView.bounds.size.height)];
    }
}



@end
