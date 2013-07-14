//
//  MetaCell.h
//  IA
//
//  Created by Hunter Brown on 7/14/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetaCell : UITableViewCell

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *valueLabel;


- (void) setTitle:(NSString *)title setValue:(NSString *)value;

+ (float) heightForValue:(NSString *)value;

@end
