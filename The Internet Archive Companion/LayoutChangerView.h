//
//  LayoutChangerView.h
//  IA
//
//  Created by Hunter on 3/8/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCollectionViewCell.h"

@interface LayoutChangerView : UIView

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CellLayoutStyle cellLayoutStyle;

@property (nonatomic, weak) IBOutlet UIButton *gridButton;
@property (nonatomic, weak) IBOutlet UIButton *listButton;


- (IBAction)didPressChangeLayoutStyleButton:(id)sender;

@end
