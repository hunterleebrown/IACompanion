//
//  ArchiveBookPageTextViewController.m
//  IA
//
//  Created by Hunter on 2/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveBookPageTextViewController.h"
#import "ArchiveDataService.h"
#import "ArchivePageViewController.h"
#import "StringUtils.h"


@interface ArchiveBookPageTextViewController ()
{
    
    NSString *useUrl;
    int start;
    int end;
    int ReadPageBytesLength;

}
@end

@implementation ArchiveBookPageTextViewController


NSInteger const ReadPageBytesLengthiPhone = 400;
NSInteger const ReadPageBytesLengthiPhoneLong = 500;
NSInteger const ReadPageBytesLengthiPadPortrait = 2200;
NSInteger const ReadPageBytesLengthiPadLandscape = 1300;


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
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"-----> useUrl: %@  start:%i  end:%i", useUrl, start, end);
    [self adjustForOrientationAndDevice];

}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //[self.bodyTextView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

    
}

- (IBAction)fontSizeChange:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FontSizeNotification" object:nil];

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    [self adjustForOrientationAndDevice];
}


- (void) loadPage{
    
    if(_file.size == 0){
        [_bodyTextView setText:@"TEXT FILE HAS NO DATA"];
    }
    
    if(start > _file.size || start + ReadPageBytesLength > _file.size){
        [_bodyTextView setText:@"END OF FILE REACHED"];
    } else {
        [_bodyTextView setAndLoadViewFromUrl:useUrl withStartByte:start withLength:ReadPageBytesLength];
    }
    [_pageNumber setText:[NSString stringWithFormat:@"%i", self.index + 1]];
    
    
    int paddingDenom = 10;
    float topPadding = 40;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        float padding = round(self.view.bounds.size.width / paddingDenom);
        [_bodyTextView setBounds:CGRectMake(padding, topPadding, self.view.bounds.size.width - padding, self.view.bounds.size.height - topPadding)];
    } 
    
    _bodyTextView.font = [UIFont fontWithName:_bodyTextView.font.fontName size:_fontSize];
}


- (void) setFontSize:(int)fontSize{
    _fontSize = fontSize;
    _bodyTextView.font = [UIFont fontWithName:_bodyTextView.font.fontName size:_fontSize];
}




- (void) adjustForOrientationAndDevice{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        ReadPageBytesLength = ReadPageBytesLengthiPadLandscape;
    } else {
        ReadPageBytesLength = ReadPageBytesLengthiPadPortrait;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     //   NSLog(@"---> [[UIScreen mainScreen] bounds].size.height: %f", [[UIScreen mainScreen] bounds].size.height);
        if([[UIScreen mainScreen] bounds].size.height == 568){
            ReadPageBytesLength = ReadPageBytesLengthiPhoneLong;
        } else {
            ReadPageBytesLength = ReadPageBytesLengthiPhone;
        }
    }
    
    
    [self getPageWithFile:_file withIndex:self.index fontSize:_fontSize];
    [self loadPage];
}


- (void) viewWillAppear:(BOOL)animated{
    
    //[self.bodyTextView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getPageWithFile:(ArchiveFile *)file withIndex:(int)index fontSize:(int)size{
    self.index = index;
    start = 0;
    _file = file;
    _fontSize = size;
    
    
    if(file.size == 0){
        return;
    }
    //double indexes = file.size / 20;
    //int pages = round(indexes);
    
    
    
    if(index > 0){
        start = ReadPageBytesLength * self.index;
    }

   // NSLog(@"->ReadPageBytesLength: %i", ReadPageBytesLength);
        
        
    useUrl = [NSString stringWithFormat:@"http://%@%@/%@", _file.server, _file.directory, [StringUtils urlEncodeString:_file.name]];
    
    
}




@end
