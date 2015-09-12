//
//  CentralViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CentralViewController.h"
#import "ArchiveSearchDoc.h"
#import "ItemContentViewController.h"
#import "NewItemViewController.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface CentralViewController ()

@end

@implementation CentralViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleContent:) name:@"ToggleContentNotification" object:nil];

	// Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNavCellSelectNotification:) name:@"NavCellNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCollectionCellSelectNotification:) name:@"CellSelectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePopToHome:) name:@"PopToHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSearchButtonPressNotification:) name:@"SearchViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSearchCreatorButtonPressNotification:) name:@"SearchViewControllerCreator" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSearchButtonClosePressNotification:) name:@"SearchViewControllerClose" object:nil];

    [self.navView setBackgroundColor:[UIColor clearColor]];



    
}






- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self doOrientationLayout:self.interfaceOrientation];

}

- (void)viewWillDisappear:(BOOL)animated {
    [self doOrientationLayout:self.interfaceOrientation];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doOrientationLayout:self.interfaceOrientation];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

}

- (void) didReceivePopToHome:(NSNotification *)notification{
    [_contentNavController popToRootViewControllerAnimated:YES];
    [self toggleContent:nil];
}

- (void) didReceiveNavCellSelectNotification:(NSNotification *)notification{
    [self closeSearch];
    ArchiveSearchDoc *aDoc = notification.object;
    
    if(aDoc.type == MediaTypeCollection){
        ItemContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
        [cvc setSearchDoc:aDoc];
        [_contentNavController pushViewController:cvc animated:YES];

//        NewItemViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"newItemViewController"];
////        [cvc setSearchDoc:aDoc];
//        [_contentNavController pushViewController:cvc animated:YES];
//        
        [self toggleContent:nil];
    
    } else {
    }
}


- (void) didReceiveCollectionCellSelectNotification:(NSNotification *)notification{
    [self closeSearch];

    ArchiveSearchDoc *aDoc = notification.object;
    

    ItemContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
    [cvc setSearchDoc:aDoc];
    [_contentNavController pushViewController:cvc animated:YES];

    
//    NewItemViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"newItemViewController"];
//    [cvc setSearchDoc:aDoc];
//    [_contentNavController pushViewController:cvc animated:YES];
    
    if(_contentView.frame.origin.x == 256 && !UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        [self moveContentViewOver];
    }
}


- (void) didReceiveSearchButtonPressNotification:(NSNotification *)notification{
    
    
    [_searchView setHidden:NO];
    [UIView animateWithDuration:0.33 animations:^{
        [_searchView setAlpha:1.0];
    } completion:^(BOOL finished) {
        if(notification.object){
            NSString *collectionId = notification.object;
            [_searchNavigationViewController popToRootViewControllerAnimated:NO];
            SearchViewController *svc = [_searchNavigationViewController.viewControllers objectAtIndex:0];
            [svc.searchBar setText:[NSString stringWithFormat:@"collection:%@ ", collectionId]];
            [svc.searchBar becomeFirstResponder];
        }
    }];
}

- (void) didReceiveSearchCreatorButtonPressNotification:(NSNotification *)notification{
    [_searchView setHidden:NO];
    [UIView animateWithDuration:0.33 animations:^{
        [_searchView setAlpha:1.0];
    } completion:^(BOOL finished) {
        if(notification.object){
            [_searchNavigationViewController popToRootViewControllerAnimated:NO];
            SearchViewController *svc = [_searchNavigationViewController.viewControllers objectAtIndex:0];
//            [svc.searchFilters setSelectedSegmentIndex:0];
            [svc.searchBar setText:notification.object];
            [svc searchBarSearchButtonClicked:svc.searchBar];
        }
    }];
}



- (void) didReceiveSearchButtonClosePressNotification:(NSNotification *)notification{

    [UIView animateWithDuration:0.33 animations:^{
        [_searchView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_searchView setHidden:YES];

    }];
    
}


- (void) closeSearch{
    [_searchView setAlpha:0.0];
    [_searchView setHidden:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contentNavController"]){
        _contentNavController = [segue destinationViewController];        
    }

    if([segue.identifier isEqualToString:@"searchEmbed"]){
        _searchNavigationViewController = [segue destinationViewController];
    }

   
}





- (IBAction) toggleContent:(id)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            [self moveContentViewBack];
            return;
        }
    }

    if(_contentView.frame.origin.x == 256){
        [self moveContentViewOver];
    } else {
        [self moveContentViewBack];
    }
}




- (IBAction)moveContentViewOver{
    // swipe left
    
    float whereToGoLeft = 0.0;
    
    if(_contentView.frame.origin.x == 256){
        whereToGoLeft = 0.0;
    } else if(_contentView.frame.origin.x == 0){
        
        if(!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            whereToGoLeft = -256;
            
        }
        
    } else if(_contentView.frame.origin.x == -256){
        whereToGoLeft = -256;
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_contentView setFrame:CGRectMake(whereToGoLeft, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStatusBarBlack" object:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if(whereToGoLeft == -256){
                [_navView setHidden:YES];
            }
        } else {
            [_navView setHidden:NO];
        }
        
    }];
    
    
    
}




- (IBAction)moveContentViewBack{
    // swipe right
    
    float whereToGoLeft = 256;
    
    if(_contentView.frame.origin.x == -256){
        whereToGoLeft = 0;
    } else if(_contentView.frame.origin.x == 0){
        whereToGoLeft = 256;
    } else if(_contentView.frame.origin.x == 256){
        whereToGoLeft = 256;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_contentView setFrame:CGRectMake(whereToGoLeft, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStatusBarWhite" object:nil];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if(whereToGoLeft == 256){
                [_navView setHidden:NO];
            }
            if(whereToGoLeft == -256){
                [_navView setHidden:YES];
            } else {
                [_navView setHidden:NO];
            }
        } else{
            [_navView setHidden:NO];
        }
    }];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect cf = _contentView.frame;
        cf.size.height = 1024;
        _contentView.frame = cf;
    }


}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect cf = _contentView.frame;
        cf.size.width = 768;
        _contentView.frame = cf;
    }
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self doOrientationLayout:toInterfaceOrientation];
    
}

- (void) doOrientationLayout:(UIInterfaceOrientation)toInterfaceOrientation{

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
            
            
           [_contentView setFrame:CGRectMake(256, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
            

        }
        
    }
    
}





@end
