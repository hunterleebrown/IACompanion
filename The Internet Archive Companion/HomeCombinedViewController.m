//
//  HomeCombinedViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeCombinedViewController.h"
#import "ArchiveSearchDoc.h"
#import "ArchiveDetailedViewController.h"
#import "HomeContentCell.h"

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


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doMoveOverForNotification) name:@"MoveOverNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveContentViewOver) name:@"MoveBackNotification" object:nil];

    [_homeNavTableView.audioService getCollectionsWithIdentifier:@"audio"];
    [_homeNavTableView.movieService getCollectionsWithIdentifier:@"movies"];
    [_homeNavTableView.textService getCollectionsWithIdentifier:@"texts"];
    
    
    [self doOrientationLayout:self.interfaceOrientation];


    
    
}


- (void) doMoveOverForNotification{
    float whereToGoLeft = 0;
    if(!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        whereToGoLeft = 0;
    } else {
        whereToGoLeft = 256;
    }

    [UIView animateWithDuration:0.3 animations:^{
        // [_contentScrollView setContentOffset:CGPointMake(_homeContentView.frame.origin.x, 0)];
        [_homeContentView setFrame:CGRectMake(whereToGoLeft, 0, _homeContentView.bounds.size.width, _homeContentView.bounds.size.height)];
        [_moreInfoView setFrame:CGRectMake(_homeContentView.frame.origin.x + _homeContentView.bounds.size.width, _moreInfoView.frame.origin.y, _moreInfoView.bounds.size.width, _moreInfoView.bounds.size.height)];
        
        [_rightContentShadow setFrame:CGRectMake(_moreInfoView.frame.origin.x, _rightContentShadow.frame.origin.y, _rightContentShadow.bounds.size.width, _rightContentShadow.bounds.size.height)];
    }];
    
    
}


- (IBAction) toggleContent{
    if(_homeContentView.frame.origin.x == 256){
        [self moveContentViewOver];
    } else {
        [self moveContentViewBack];
    }

}


- (IBAction) moveContentViewOver{
    // swipe left

    float whereToGoLeft = 0.0;
    
    if(_homeContentView.frame.origin.x == 256){
        whereToGoLeft = 0.0;
    } else if(_homeContentView.frame.origin.x == 0){
        
        if(!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            whereToGoLeft = -256;
        }
        
    } else if(_homeContentView.frame.origin.x == -256){
        whereToGoLeft = -256;
    }
    
   // if(!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        [UIView animateWithDuration:0.3 animations:^{
           // [_contentScrollView setContentOffset:CGPointMake(_homeContentView.frame.origin.x, 0)];
            [_homeContentView setFrame:CGRectMake(whereToGoLeft, 0, _homeContentView.bounds.size.width, _homeContentView.bounds.size.height)];
            [_moreInfoView setFrame:CGRectMake(_homeContentView.frame.origin.x + _homeContentView.bounds.size.width, _moreInfoView.frame.origin.y, _moreInfoView.bounds.size.width, _moreInfoView.bounds.size.height)];
            
            [_rightContentShadow setFrame:CGRectMake(_homeContentView.frame.origin.x + _homeContentView.bounds.size.width, _rightContentShadow.frame.origin.y, _rightContentShadow.bounds.size.width, _rightContentShadow.bounds.size.height)];
        }];
   // }
    
    
    
    
}


- (IBAction) moveContentViewBack{
    // swipe right
    
    float whereToGoLeft = 256;
    
    if(_homeContentView.frame.origin.x == -256){
        whereToGoLeft = 0;
    } else if(_homeContentView.frame.origin.x == 0){
        whereToGoLeft = 256;
    } else if(_homeContentView.frame.origin.x == 256){
        whereToGoLeft = 256;
    }

  //  if(!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        [UIView animateWithDuration:0.3 animations:^{
            // [_contentScrollView setContentOffset:CGPointMake(_homeContentView.frame.origin.x, 0)];
            [_homeContentView setFrame:CGRectMake(whereToGoLeft, 0, _homeContentView.bounds.size.width, _homeContentView.bounds.size.height)];
            [_moreInfoView setFrame:CGRectMake(_homeContentView.frame.origin.x + _homeContentView.bounds.size.width, _moreInfoView.frame.origin.y, _moreInfoView.bounds.size.width, _moreInfoView.bounds.size.height)];
            
            [_rightContentShadow setFrame:CGRectMake(_homeContentView.frame.origin.x + _homeContentView.bounds.size.width, _rightContentShadow.frame.origin.y, _rightContentShadow.bounds.size.width, _rightContentShadow.bounds.size.height)];
        }];
    //}



}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([[segue identifier] isEqualToString:@"homeCellPush"]){
    
        HomeContentCell *cell = (HomeContentCell *)sender;
        ArchiveSearchDoc *doc = cell.doc;
        
        ArchiveDetailedViewController *detailViewController = [segue destinationViewController];
        [detailViewController setTitle:doc.title];
        [detailViewController setIdentifier:doc.identifier];
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_homeContentView.homeContentTableView deselectRowAtIndexPath:_homeContentView.homeContentTableView.indexPathForSelectedRow animated:YES];
    [self doOrientationLayout:self.interfaceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
 //   [self.contentScrollView setContentSize:CGSizeMake((self.contentScrollView.homeNavTableView.bounds.size.width + self.contentScrollView.homeContentView.bounds.size.width), 10)];
  //  [self.contentScrollView.homeNavTableView reloadData];
   // [self.contentScrollView.homeContentView.homeContentTableView reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
            [_homeContentView setFrame:CGRectMake(256, 0, _homeContentView.bounds.size.width, _homeContentView.bounds.size.height)];
        }
    }
    [_rightContentShadow setFrame:CGRectMake(_homeContentView.frame.origin.x + _homeContentView.bounds.size.width, _rightContentShadow.frame.origin.y, _rightContentShadow.bounds.size.width, _rightContentShadow.bounds.size.height)];

}


#pragma mark - scroll view  

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   // [self.contentScrollView.homeContentView.aSearchBar resignFirstResponder];
}


- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}



@end
