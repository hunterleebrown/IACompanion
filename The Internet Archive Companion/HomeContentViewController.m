//
//  HomeContentViewController.m
//  IA
//
//  Created by Hunter on 5/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeContentViewController.h"
#import "HomeContentCell.h"
#import "ArchiveDetailedViewController.h"

@interface HomeContentViewController ()

@end

@implementation HomeContentViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNavCellSelectNotification:) name:@"NavCellSelectNotification" object:nil];

}

- (void) viewDidAppear:(BOOL)animated{

    NSURL *blogUrl = [NSURL URLWithString:@"http://blog.archive.org/category/announcements/"];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:blogUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [_homeContentView.iABlogWebView loadRequest:req];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) gotNavCellSelectNotification:(NSNotification *)notification{

    
    ArchiveSearchDoc *aDoc = notification.object;
    HomeContentCell *cell = [HomeContentCell new];
    [cell setDoc:aDoc];
    [self performSegueWithIdentifier:@"homeCellPush" sender:cell];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"homeCellPush"]){
        
        HomeContentCell *cell = (HomeContentCell *)sender;
        ArchiveSearchDoc *doc = cell.doc;
        
        ArchiveDetailedViewController *detailViewController = [segue destinationViewController];
        //[detailViewController setTitle:doc.title];
        [detailViewController setIdentifier:doc.identifier];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveOverNotification" object:nil];

    }
    
    
}

@end
