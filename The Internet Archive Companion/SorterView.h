//
//  SorterView.h
//  IA
//
//  Created by Hunter Brown on 3/4/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAJsonDataService.h"

@interface SorterView : UIView

@property (nonatomic, weak) IBOutlet UIButton *relevanceButton;
@property (nonatomic, weak) IBOutlet UIButton *titleButton;
@property (nonatomic, weak) IBOutlet UIButton *viewsButton;
@property (nonatomic, weak) IBOutlet UIButton *dateButton;

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;

@property (nonatomic) IADataServiceSortType selectedSortType;
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) IAJsonDataService *service;

- (void)resetSortButtons;
- (void)serviceDidReturn;


@end
