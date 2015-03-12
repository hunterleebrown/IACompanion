//
//  ArchiveContentTypeControlView.h
//  IA
//
//  Created by Hunter on 3/11/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"

@interface ArchiveContentTypeControlView : UIView

@property (copy) void (^selectButtonBlock)(NSString *param);
@property (nonatomic) MediaType currentMediaType;

- (NSString *)filterQueryParam:(MediaType)type;
- (NSString *)selectedFilters;

@end
