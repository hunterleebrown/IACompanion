//
//  ArchiveBookPageTextViewController.m
//  IA
//
//  Created by Hunter on 2/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveBookPageTextViewController.h"
#import "ArchiveDataService.h"
@interface ArchiveBookPageTextViewController ()
{
    ArchiveDataService *service;

}
@end

@implementation ArchiveBookPageTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        service = [ArchiveDataService new];
        [service setDelegate:self];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getPageWithFile:(ArchiveFile *)file withIndex:(int)index{
    _index = index;
    int start = 0;
    int end = 199;
    if(file.size == 0){
        return;
    }
    double indexes = file.size / 20;
    int pages = round(indexes);
    if(index > 0){
        start = 200 * _index;
        end = (start + 200) - 1;
    }
    
 //   NSLog(@"-----> file.server: %@", file.server);
    
    NSString *useUrl = [NSString stringWithFormat:@"http://%@%@/%@", file.server, file.directory, file.name];
    
    [service doRangeRequestFromRange:start toRange:end fromUrl:useUrl];


}

- (void)dataDidFinishLoadingWithRangeRequestResults:(NSString *)results{
   [_bodyTextView setText:results];


}



@end
