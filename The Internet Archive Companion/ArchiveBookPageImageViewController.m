//
//  ArchiveBookPageImageViewController.m
//  IA
//
//  Created by Hunter Brown on 2/11/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveBookPageImageViewController.h"


// http://ia600305.us.archive.org/BookReader/BookReaderImages.php?zip=/14/items/adventuresalices00carrrich/adventuresalices00carrrich_jp2.zip&file=adventuresalices00carrrich_jp2/adventuresalices00carrrich_0001.jp2&scale=4&rotate=0


NSString *const BookReaderImagesPHP = @"/BookReader/BookReaderImages.php?";

@interface ArchiveBookPageImageViewController () {
    NSString *bookReaderPHP;

}



@end





@implementation ArchiveBookPageImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [_scrollView setUserInteractionEnabled:YES];
        [_scrollView setShowsVerticalScrollIndicator:YES];
        [_scrollView setShowsHorizontalScrollIndicator:YES];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        //set the zooming properties of the scroll view
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 10.0;

        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        
        

    }
    return self;
}



- (void) setPageWithServer:(NSString *)server withZipFileLocation:(NSString *)zipFile withFileName:(NSString *)name withIdentifier:(NSString *)identifier withIndex:(int)index{

    _server = server;
    _zipFile = zipFile;
    _identifier = identifier;
    self.index = index;
    _name = name;

    NSString *page = [name substringWithRange:NSMakeRange(0, (name.length - 8))];
    _url = [NSString stringWithFormat:@"http://%@%@zip=%@&file=%@_jp2/%@_%@.jp2&scale=2", _server, BookReaderImagesPHP, _zipFile, page, page, [NSString stringWithFormat:@"%04d", self.index]];
  //  NSLog(@"------> page: %@", page);
   // NSLog(@"------> url: %@", _url);
    [_aSyncImageView setAndLoadImageFromUrl:_url];
    [_pageNumber setText:[NSString stringWithFormat:@"%i", self.index ]];
}


- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.aSyncImageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];


}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

}


- (void) viewWillAppear:(BOOL)animated{

    [self.aSyncImageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

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


- (BOOL) shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
    
    
}



- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"GOT A ZOOM");
    
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"GOT A ZOOM DID END");
    
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    
    
}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _aSyncImageView;
}


@end
