//
//  LayoutChangerView.m
//  IA
//
//  Created by Hunter on 3/8/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "LayoutChangerView.h"
#import "FontMapping.h"

@interface LayoutChangerView ()

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation LayoutChangerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.cellLayoutStyle = CellLayoutStyleGrid;
    }
    return self;
}


- (IBAction)didPressChangeLayoutStyleButton:(id)sender
{
    self.gridButton.selected = NO;
    self.listButton.selected = NO;

    self.cellLayoutStyle = self.cellLayoutStyle == CellLayoutStyleCompact ? CellLayoutStyleGrid : CellLayoutStyleCompact;

    self.selectedButton = self.cellLayoutStyle == CellLayoutStyleGrid ? self.gridButton : self.listButton;
    self.selectedButton.selected = YES;

    [self.collectionView.collectionViewLayout invalidateLayout];

    [self.collectionView setContentOffset:CGPointMake(0, 66) animated:YES];

}


- (void)layoutSubviews
{

    if(!self.selectedButton)
    {
        self.selectedButton = self.gridButton;
        self.selectedButton.selected = YES;
    }

    for(UIButton *button in @[self.gridButton, self.listButton])
    {
        [button.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:25]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTintColor:[UIColor darkGrayColor]];
    }


    [self.gridButton setTitle:GRID forState:UIControlStateNormal];
    [self.listButton setTitle:HAMBURGER forState:UIControlStateNormal];

    [super layoutSubviews];

}

@end
