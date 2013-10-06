//
//  CentralViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "CentralViewController.h"
#import "ArchiveSearchDoc.h"
#import "CollectionContentViewController.h"
#import "ItemContentViewController.h"
#import "SearchViewController.h"


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSearchButtonClosePressNotification:) name:@"SearchViewControllerClose" object:nil];

    //[self doOrientationLayout:self.interfaceOrientation];


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

}

- (void) didReceivePopToHome:(NSNotification *)notification{
    [_contentNavController popToRootViewControllerAnimated:YES];
    [self toggleContent:nil];
}

- (void) didReceiveNavCellSelectNotification:(NSNotification *)notification{
    [self closeSearch];
    ArchiveSearchDoc *aDoc = notification.object;
    
    if(aDoc.type == MediaTypeCollection){
        CollectionContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"collectionViewController"];
        [cvc setSearchDoc:aDoc];
        [_contentNavController pushViewController:cvc animated:YES];
        [self toggleContent:nil];
    
    } else {
    }
}


- (void) didReceiveCollectionCellSelectNotification:(NSNotification *)notification{
    [self closeSearch];

    ArchiveSearchDoc *aDoc = notification.object;
    
    if(aDoc.type == MediaTypeCollection){
        CollectionContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"collectionViewController"];
        [cvc setSearchDoc:aDoc];
        [_contentNavController pushViewController:cvc animated:YES];
        
    } else {
        ItemContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
        [cvc setSearchDoc:aDoc];
        [_contentNavController pushViewController:cvc animated:YES];
    }
    
    
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
            [_searchViewController.searchBar setText:[NSString stringWithFormat:@"collection:%@ ", collectionId]];
        }
    }];
    
}

- (void) didReceiveSearchButtonClosePressNotification:(NSNotification *)notification{
    // SearchViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    //[_contentNavController pushViewController:svc animated:YES];
    [UIView animateWithDuration:0.33 animations:^{
        [_searchView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_searchView setHidden:YES];

    }];
    
}


- (void) closeSearch{
    [_searchView setAlpha:0.0];
    [_searchView setHidden:YES];
    [_searchViewController.searchBar resignFirstResponder];
    [_searchViewController.searchResultsTable deselectRowAtIndexPath:_searchViewController.searchResultsTable.indexPathForSelectedRow animated:YES];

}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contentNavController"]){
        _contentNavController = [segue destinationViewController];        
    }

    if([segue.identifier isEqualToString:@"searchEmbed"]){
        _searchViewController = [segue destinationViewController];
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
