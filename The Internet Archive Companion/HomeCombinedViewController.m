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


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveContentViewOver:) name:@"MoveOverScrollerNotification" object:nil];

    [_contentScrollView.homeNavTableView.audioService getCollectionsWithIdentifier:@"audio"];
    [_contentScrollView.homeNavTableView.movieService getCollectionsWithIdentifier:@"movies"];
    [_contentScrollView.homeNavTableView.textService getCollectionsWithIdentifier:@"texts"];
    
    
    [self doOrientationLayout:self.interfaceOrientation];

    
    
}

- (void) moveContentViewOver:(NSNotification *)notification{

    if(!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        [UIView animateWithDuration:0.3 animations:^{
            [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.homeContentView.frame.origin.x, 0)];
        }];
    }
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
    [self.contentScrollView.homeContentView.homeContentTableView deselectRowAtIndexPath:self.contentScrollView.homeContentView.homeContentTableView.indexPathForSelectedRow animated:YES];
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
    [self.contentScrollView setContentSize:CGSizeMake((self.contentScrollView.homeNavTableView.bounds.size.width + self.contentScrollView.homeContentView.bounds.size.width), 10)];
    [self.contentScrollView.homeNavTableView reloadData];
    [self.contentScrollView.homeContentView.homeContentTableView reloadData];
    
}


#pragma mark - scroll view  

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.contentScrollView.homeContentView.aSearchBar resignFirstResponder];
}


- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}



@end
