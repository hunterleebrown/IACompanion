//
//  IAJsonService.h
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IADataService.h"

@interface IAJsonDataService : IADataService
@property (nonatomic, strong) NSMutableDictionary *rawResults;


- (id) initForAllItemsWithCollectionIdentifier:(NSString *)idString;

@end
