//
//  ArchiveShareViewController.m
//  IA
//
//  Created by Hunter on 2/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveShareViewController.h"
#import "ArchiveShareTableViewCell.h"
#import "AsyncImage.h"
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
    if((_archiveIdentifier == nil) && ! _imageUrl){
        [_myPopOverController dismissPopoverAnimated:YES];
    
    } else {
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
            [_myPopOverController dismissPopoverAnimated:YES];

        };
        controller.completionHandler =myBlock;
        NSString *archiveUrl;
        
        if(_imageUrl){
            archiveUrl = _imageUrl;
        } else {
            archiveUrl = [NSString stringWithFormat:@"http://archive.org/details/%@", self.archiveIdentifier];
            
        }
        
        [controller addURL:[NSURL URLWithString:archiveUrl]];
        [controller setInitialText:[NSString stringWithFormat:@"@Internet Archive - %@", self.archiveTitle]];
     /*   if(_imageUrl) {
            AsyncImage *aSync = [AsyncImage new];
            [aSync setAndLoadImageFromUrl:_imageUrl];
            [controller addImage:aSync.image];
        }
      */ 
      [self presentViewController:controller animated:YES completion:nil];
    }
    
    
    
    
    
    
    
}

@end
