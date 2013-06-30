//
//  ContnetViewController.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

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
    
    UIImage *image = [UIImage imageNamed:@"list.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 10, image.size.height);
    button.tag = 0;
    [button addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    
    UIImage *image2 = [UIImage imageNamed:@"search-button.png"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, image2.size.width /2.2, image2.size.height / 2.2);
    button2.tag = 0;
   // [button2 addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:image2 forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
    UIImage *image3 = [UIImage imageNamed:@"ia-button.png"];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(0, 0, round(image3.size.width * .66), round(image3.size.height * .66));
    button3.tag = 0;
    
    // [button2 addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    [button3 setImage:image3 forState:UIControlStateNormal];
    
    
    
    [self.navigationItem setLeftBarButtonItems:@[buttonItem]];
    [self.navigationItem setRightBarButtonItems:@[buttonItem2]];
    [self.navigationItem setTitleView:button3];
    
}

- (void) didPressListButton{
   // [[NSNotificationCenter defaultCenter] pos]
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleContentNotification" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
