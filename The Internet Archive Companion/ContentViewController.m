//
//  ContnetViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ContentViewController.h"
#import "ArchiveSearchDoc.h"
#import "CollectionContentViewController.h"
#import "ItemContentViewController.h"
#import "PopUpView.h"

@interface ContentViewController () 


@end

@implementation ContentViewController
@synthesize service, popUpView;

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
    
    UIImage *image = [UIImage imageNamed:@"new-list.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 10, image.size.height);
    button.tag = 0;
    [button addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    _listButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    
    UIImage *image2 = [UIImage imageNamed:@"search-button-plain.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, image2.size.width + 10, image2.size.height);
    button2.tag = 0;
   // [button2 addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:image2 forState:UIControlStateNormal];
    _searchButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
    UIImage *bi = [UIImage imageNamed:@"back-button.png"];
    UIButton *bibutton = [UIButton buttonWithType:UIButtonTypeCustom];
    bibutton.frame = CGRectMake(0, 0, bi.size.width, bi.size.height);
    bibutton.tag = 0;
    [bibutton addTarget:self action:@selector(didPressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [bibutton setImage:bi forState:UIControlStateNormal];
    
    _backButton = [[UIBarButtonItem alloc] initWithCustomView:bibutton];
    
    [self.navigationItem setLeftBarButtonItems:@[_listButton]];


    [self.navigationItem setRightBarButtonItems:@[_searchButton]];
    
    
    popUpView = [[PopUpView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:popUpView];
    

}
    

- (void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];

}

- (void) setSearchDoc:(ArchiveSearchDoc *)searchDoc{
    _searchDoc = searchDoc;
    self.service = [[IAJsonDataService alloc] initForMetadataDocsWithIdentifier:_searchDoc.identifier];
    [self.service setDelegate:self];
}



- (void) didPressListButton{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];    
}





- (void) didPressBackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
