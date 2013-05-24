//
//  ArchivePageViewController.m
//  IA
//
//  Created by Hunter on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchivePageViewController.h"
#import "ArchivePageTextSizeViewController.h"
#import "ArchiveBookPageTextViewController.h"

@interface ArchivePageViewController () {
    ArchivePageTextSizeViewController *tsvc;
}

@end

@implementation ArchivePageViewController

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
    if(self){
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _fontSizeForAll = 14;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFontSize:) name:@"FontSizeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popMeBack:) name:@"PopPageControllerNotification" object:nil];


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

- (void) doFontSize:(NSNotification *)notification{
    UIButton *button = notification.object;
    [self changeFontSize:button.tag];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"fontSizeSegue"]){
        
        tsvc = (ArchivePageTextSizeViewController *)[segue destinationViewController];
        tsvc.delegate = self;
        _popper = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _popper.delegate = self;
        //  [_popper setPassthroughViews:@[_fontButton]];
        [tsvc setMyPop:_popper];
        
    }
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    _popper = nil;
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
   return _popper ? NO : YES;
}


- (void) changeFontSize:(int)size{
    if(_fontSizeForAll + size >= 10 && _fontSizeForAll + size <= 24) {
        _fontSizeForAll = _fontSizeForAll + size;
        for(UIViewController *child in self.childViewControllers) {
            
            if([child isKindOfClass:[ArchiveBookPageTextViewController class]]){
                ArchiveBookPageTextViewController *txtPage = (ArchiveBookPageTextViewController *)child;
                [txtPage setFontSize:_fontSizeForAll];
            }
        }

        if(_fontChangeDelegate && [_fontChangeDelegate respondsToSelector:@selector(changeFontSizeOfChildControllers:)]) {
            [_fontChangeDelegate changeFontSizeOfChildControllers:_fontSizeForAll];
        }
    }

}


- (void)popMeBack:(NSNotification *)notification{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
