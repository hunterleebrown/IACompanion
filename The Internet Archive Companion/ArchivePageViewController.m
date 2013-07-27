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
#import "ArchiveBookPageImageViewController.h"
#import "ArchiveFile.h"


@interface ArchivePageViewController ()


//ArchiveBookPageImageViewController *firstPage;
//NSMutableArray *pages;
//NSMutableDictionary *pageDictionary;

@property (nonatomic, strong) ArchiveBookPageImageViewController *firstPage;
@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, strong) NSMutableDictionary *pageDictionary;
@end

@implementation ArchivePageViewController

@synthesize firstPage, pages, pageDictionary, bookFile;


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
    
    
    pages = [NSMutableArray new];
    pageDictionary = [NSMutableDictionary new];
    
    _fontSizeForAll = 14;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFontSize:) name:@"FontSizeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popMeBack:) name:@"PopPageControllerNotification" object:nil];

    
    [self setPagesWithIndex:0];
    firstPage = [pages objectAtIndex:2];

    
    [self setDataSource:self];
    [self setDelegate:self];
    [self setFontChangeDelegate:self];
    [self setViewControllers:@[firstPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    

    [pages setObject:firstPage atIndexedSubscript:0];

}

- (void) setBookFile:(ArchiveFile *)bf{
    bookFile = bf;
}


#pragma mark - page view controller
/* Stupid, but works */

- (ArchiveBookPageImageViewController *) pageControllerForIndex:(int)index{
    
    
    ArchiveBookPageImageViewController *p0;
    ArchiveBookPageImageViewController *p1;
    
    ArchiveBookPageImageViewController *p2;
    
    ArchiveBookPageImageViewController *p3;
    ArchiveBookPageImageViewController *p4;
    
    
    
    
    if([pages objectAtIndex:0]){
        p0 = [pages objectAtIndex:0];
    }
    if([pages objectAtIndex:1]){
        p1 = [pages objectAtIndex:1];
        
    }
    if([pages objectAtIndex:2]){
        p2 = [pages objectAtIndex:2];
    }
    if([pages objectAtIndex:3]){
        p3 = [pages objectAtIndex:3];
    }
    if([pages objectAtIndex:4]){
        p4 = [pages objectAtIndex:4];
    }
    
    
    
    if(p0.index == index){
        [self setPagesWithIndex:index];
        return p0;
    }
    else if(p1.index == index){
        [self setPagesWithIndex:index];
        return p1;
    }
    else if(p2.index == index){
        [self setPagesWithIndex:index];
        return p2;
    }
    else if(p3.index == index){
        [self setPagesWithIndex:index];
        return p3;
    }
    else if(p4.index == index){
        [self setPagesWithIndex:index];
        return p4;
    }
    else {
        [self setPagesWithIndex:index];
        return [pages objectAtIndex:2];
    }
    
    
}

- (void) setPagesWithIndex:(int)index{
    [pages setObject:[self newPageControllerWithIndex:index - 2] atIndexedSubscript:0];
    [pages setObject:[self newPageControllerWithIndex:index - 1] atIndexedSubscript:1];
    [pages setObject:[self newPageControllerWithIndex:index] atIndexedSubscript:2];
    [pages setObject:[self newPageControllerWithIndex:index + 1] atIndexedSubscript:3];
    [pages setObject:[self newPageControllerWithIndex:index + 2] atIndexedSubscript:4];
    
}


- (void) changeFontSizeOfChildControllers:(int)size{
    //   NSLog(@" ---------> change child fontsize to: %i", size);
    
    for(UIViewController *vc in pages){
        if([vc isKindOfClass:[ArchiveBookPageTextViewController class]]) {
            ArchiveBookPageTextViewController *tvc = (ArchiveBookPageTextViewController *)vc;
            [tvc setFontSize:self.fontSizeForAll];
        }
    }
    
    
}

- (UIViewController *) newPageControllerWithIndex:(int)index{
    
    
    if(bookFile.format == FileFormatDjVuTXT || bookFile.format == FileFormatTxt){
        
        ArchiveBookPageTextViewController *page = [[ArchiveBookPageTextViewController alloc] initWithNibName:@"ArchiveBookPageTextViewController" bundle:nil];
        int fontSize = 14;
            fontSize = self.fontSizeForAll;
        [page getPageWithFile:bookFile withIndex:index fontSize:fontSize];
        
        return page;
        
    } else {
        
        ArchiveBookPageImageViewController *page = [[ArchiveBookPageImageViewController alloc] initWithNibName:@"ArchiveBookPageImageViewController" bundle:nil];
        [page setPageWithServer:bookFile.server withZipFileLocation:[NSString stringWithFormat:@"%@/%@", bookFile.directory, bookFile.name] withFileName:bookFile.name withIdentifier:_identifier withIndex:index];
        return page;
        
    }
    
}





- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ArchiveBookPageImageViewController *)viewController{
    
    // NSLog(@"---> currentIndex: %i", viewController.index);
    
    
    return [self pageControllerForIndex:viewController.index + 1];
}


- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ArchiveBookPageImageViewController *)viewController{
    
    //NSLog(@"---> currentIndex: %i", viewController.index);
    
    
    if(viewController.index == 0){
        return firstPage;
    } else{
        
        return [self pageControllerForIndex:viewController.index - 1];
        
    }
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
