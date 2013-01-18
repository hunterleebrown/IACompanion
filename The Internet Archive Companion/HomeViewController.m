//
//  ViewController.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeViewController.h"
#import "ArchiveDataService.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"homeNav"]){
        // Save the edit button's info so we can restore it
        saveEditAction = [sender action];
        saveEditTarget = [sender target];
        saveEditSender = sender;
        
        // Change the edit button's target to us, and its action to dismiss the popover
        [sender setAction:@selector(dismissPopover:)];
        [sender setTarget:self];
        
        // Save the popover controller and set ourselves as the its delegate so we can
        // restore the button action when this popover is dismissed (this happens when the popover
        // is dismissed by tapping outside the view, not by tapping the edit button again)
        homeNavPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        homeNavPopoverController.delegate = (id <UIPopoverControllerDelegate>)self;
    
    
    }
}

-(void)dismissPopover:(id)sender
{
    // Restore the buttons actions before we dismiss the popover
    [saveEditSender setAction:saveEditAction];
    [saveEditSender setTarget:saveEditTarget];
    [homeNavPopoverController dismissPopoverAnimated:YES];
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    // A tap occurred outside of the popover.
    // Restore the button actions before its dismissed.
    [saveEditSender setAction:saveEditAction];
    [saveEditSender setTarget:saveEditTarget];
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Before we navigate away from this view (the back button was pressed)
    // remove the edit popover (if it exists).
    [self dismissPopover:saveEditSender];
}


@end
