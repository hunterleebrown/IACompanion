//
//  ArchiveShareViewController.m
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveShareViewController.h"
#import "ArchiveShareTableViewCell.h"
#import <Social/Social.h>

@interface ArchiveShareViewController ()

@end

@implementation ArchiveShareViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)doShare:(id)sender{

    UIButton *button = (UIButton *)sender;
    NSLog(@"------> button.tag: %i", button.tag);
    if(_archiveIdentifier == nil){
       // [_myPopOverController dismissPopoverAnimated:YES];
        
    } else {
        
        if(button.tag == 0 || button.tag == 1) {
            NSString *serviceType = button.tag == 0 ? SLServiceTypeFacebook : SLServiceTypeTwitter;
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    //NSLog(@"ResultCancelled");
                    
                } else
                    
                {
                    //NSLog(@"Success");
                }
                [controller dismissViewControllerAnimated:YES completion:Nil];
                //[_myPopOverController dismissPopoverAnimated:YES];
                
            };
            controller.completionHandler = myBlock;
            NSString *archiveUrl = [NSString stringWithFormat:@"http://archive.org/details/%@", self.archiveIdentifier];
            [controller addURL:[NSURL URLWithString:archiveUrl]];
            [controller setInitialText:[NSString stringWithFormat:@"@Internet Archive - %@", self.archiveTitle]];
            if(_image) {
                //   [controller addImage:_image];
            }
            
            [self presentViewController:controller animated:YES completion:nil];
        } else if(button.tag == 2){
            
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setSubject:self.archiveTitle];
                [mailViewController setMessageBody:[self shareMessage] isHTML:YES];
                [self presentViewController:mailViewController animated:YES completion:nil];
            } else {
                [self displayUnableToSendEmailMessage];
            } 
        }
    }
}

- (void)displayUnableToSendEmailMessage {
    NSString *errorMessage = @"The device is unable to send email in its current state.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Send Email"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)displayEmailSentMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent"
                                                    message:@"Your message was successfully sent."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];    
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:( MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            //  NSLog(@"Message Canceled");
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Message Saved");
            break;
        case MFMailComposeResultSent:
            [self displayEmailSentMessage];
            break;
        case MFMailComposeResultFailed:
            // NSLog(@"Message Failed");
            break;
        default:
            //  NSLog(@"Message Not Sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (NSString *)shareMessage{

    return [NSString stringWithFormat:@"From the Internet Archive: %@", [NSString stringWithFormat:@"http://archive.org/details/%@", self.archiveIdentifier]];
}


- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}

@end
