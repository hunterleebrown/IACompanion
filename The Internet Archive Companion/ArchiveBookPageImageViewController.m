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

@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *zipFile;
@property (nonatomic) int index;

@end





@implementation ArchiveBookPageImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithZipFileLocation:(NSString *)zipFile withIdentifier:(NSString *)identifier withIndex:(int)index{

    self = [super init];
    if(self){
        _zipFile = zipFile;
        _identifier = identifier;
        _index = index;
        
        
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

@end
