//
//  SorterView.m
//  IA
//
//  Created by Hunter Brown on 3/4/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "SorterView.h"
#import "FontMapping.h"

@implementation SorterView


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleButton.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:20]];
    [self.viewsButton.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:20]];
    [self.dateButton.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:20]];
    
    [self.titleButton setTitle:TEXTASC forState:UIControlStateNormal];
    [self.viewsButton setTitle:VIEWS forState:UIControlStateNormal];
    [self.dateButton setTitle:CLOCK forState:UIControlStateNormal];
    
    self.relevanceButton.enabled = NO;
    self.titleButton.enabled = NO;
    self.viewsButton.enabled = NO;
    self.dateButton.enabled = NO;

    [self.toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setBackgroundColor:[UIColor clearColor]];

    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.85];


}

# pragma mark - bottom sort buttons

- (IBAction)sortButtonPressed:(id)sender
{
    IADataServiceSortType type;
    
    self.selectedButton.selected = NO;
    
    if(sender == self.dateButton)
    {
        type = IADataServiceSortTypeDateDescending;
        [self.dateButton setTitle:[NSString stringWithFormat:@"%@%@", CLOCK, DOWN] forState:UIControlStateNormal];
        if(type == self.selectedSortType)
        {
            type = IADataServiceSortTypeDateAscending;
            [self.dateButton setTitle:[NSString stringWithFormat:@"%@%@", CLOCK, UP] forState:UIControlStateNormal];
        }
        [self.viewsButton setTitle:VIEWS forState:UIControlStateNormal];
        [self.titleButton setTitle:TEXTASC forState:UIControlStateNormal];
        
    }
    else if(sender == self.titleButton)
    {
        type = IADataServiceSortTypeTitleAscending;
        [self.titleButton setTitle:TEXTASC forState:UIControlStateNormal];
        if(type == self.selectedSortType)
        {
            type = IADataServiceSortTypeTitleDescending;
            [self.titleButton setTitle:TEXTDSC forState:UIControlStateNormal];
        }
        [self.viewsButton setTitle:VIEWS forState:UIControlStateNormal];
        [self.dateButton setTitle:CLOCK forState:UIControlStateNormal];
        
    }
    else if(sender == self.viewsButton)
    {
        type = IADataServiceSortTypeDownloadDescending;
        [self.viewsButton setTitle:[NSString stringWithFormat:@"%@%@", VIEWS, DOWN] forState:UIControlStateNormal];
        
        if(type == self.selectedSortType)
        {
            type = IADataServiceSortTypeDownloadAscending;
            [self.viewsButton setTitle:[NSString stringWithFormat:@"%@%@", VIEWS, UP] forState:UIControlStateNormal];
        }
        [self.dateButton setTitle:CLOCK forState:UIControlStateNormal];
        [self.titleButton setTitle:TEXTASC forState:UIControlStateNormal];
        
    }
    else
    {
        type = IADataServiceSortTypeNone;
        [self.viewsButton setTitle:VIEWS forState:UIControlStateNormal];
        [self.titleButton setTitle:TEXTASC forState:UIControlStateNormal];
        [self.dateButton setTitle:CLOCK forState:UIControlStateNormal];
        
    }
    

    
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    
    [self.service searchChangeSortType:type];
    [self.service forceFetchData];
    self.selectedSortType = type;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:YES]];
    
    
    
    
    
}

- (void)resetSortButtons
{
    
    [self.viewsButton setTitle:VIEWS forState:UIControlStateNormal];
    [self.titleButton setTitle:TEXTASC forState:UIControlStateNormal];
    [self.dateButton setTitle:CLOCK forState:UIControlStateNormal];
    
    
    for(UIButton *button in @[self.relevanceButton, self.dateButton, self.titleButton, self.viewsButton])
    {
        [button setSelected:NO];
    }
    
    self.selectedButton = nil;
    self.selectedSortType = nil;
}



- (void) serviceDidReturn {
    
    if (!self.selectedButton)
    {
        [self.relevanceButton setSelected:YES];
        self.selectedButton = self.relevanceButton;
    }
    
    for(UIButton *button in @[self.relevanceButton, self.dateButton, self.titleButton, self.viewsButton])
    {
        [button setEnabled:YES];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
