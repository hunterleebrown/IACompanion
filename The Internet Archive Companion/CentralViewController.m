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

}


- (void) didReceiveNavCellSelectNotification:(NSNotification *)notification{
    
    ArchiveSearchDoc *aDoc = notification.object;
    
    if(aDoc.type == MediaTypeCollection){
        CollectionContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"collectionViewController"];
        [cvc setSearchDoc:aDoc];
        [_contentNavController pushViewController:cvc animated:YES];
        [self toggleContent:nil];
    
    } else {
        //      [self performSegueWithIdentifier:@"itemViewController" sender:nil];
    }
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"contentNavController"]){
        _contentNavController = [segue destinationViewController];        
    }
    

   
}





- (void) toggleContent:(id)sender {

    if(_contentView.frame.origin.x == 256){
        [self moveContentViewOver];
    } else {
        [self moveContentViewBack];
    }
}




- (void) moveContentViewOver{
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




- (void) moveContentViewBack{
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








@end
