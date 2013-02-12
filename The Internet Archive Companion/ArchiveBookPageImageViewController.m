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

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *zipFile;
@property (nonatomic, retain) NSString *index;

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

- (id) initWithServer:(NSString *)server withZipFileLocation:(NSString *)zipFile withFileName:(NSString *)name withIdentifier:(NSString *)identifier withIndex:(NSString *)index{

    self = [super init];
    if(self){
        _server = server;
        _zipFile = zipFile;
        _identifier = identifier;
        _index = index;
        _name = name;
        
        self.aSyncImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [self.aSyncImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:self.aSyncImageView];


        NSString *page = [name substringWithRange:NSMakeRange(0, (name.length - 8))];

        NSString *url = [NSString stringWithFormat:@"http://%@%@zip=%@&file=%@_jp2/%@_%@.jp2&scale=2", _server, BookReaderImagesPHP, _zipFile, page, page, _index];

        NSLog(@"------> page: %@", page);

        NSLog(@"------> url: %@", url);
        [_aSyncImageView setAndLoadImageFromUrl:url];
        
        
        // good: http://ia701208.us.archive.org/BookReader/BookReaderImages.php?zip=/24/items/AlicesAdventuresInWonderland_841/86311283-Original-Version-of-Alice-s-Adventures-in-Wonderland-by-Lewis-Carroll_jp2.zip&file=86311283-Original-Version-of-Alice-s-Adventures-in-Wonderland-by-Lewis-Carroll_jp2/86311283-Original-Version-of-Alice-s-Adventures-in-Wonderland-by-Lewis-Carroll_0000.jp2&scale=2&rotate=0
      
        // bad:  http://ia701208.us.archive.org/BookReader/BookReaderImages.php?zip=/24/items/AlicesAdventuresInWonderland_841/86311283-Original-Version-of-Alice-s-Adventures-in-Wonderland-by-Lewis-Carroll_jp2.zip&file=86311283-Original-Version-of-Alice-s-Adventures-in-Wonderland-by-Lewis-Carroll_jp2/86311283-Original-Version-of-Alice-s-Adventures-in-Wonderland-by-Lewis-Carroll_0000.jp2&scale=4

        

    }
    return self;
    
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
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

@end
