//
//  SimpleCache.h
//  IA
//
//  Created by Hunter on 9/27/15.
//  Copyright © 2015 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleCache : NSObject


@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dictionary;

+ (SimpleCache *)sharedInstance;


- (void)addItem:(NSObject *)object withIdentifier:(NSString *)identifier;
- (void)removeItemWithIdentifier:(NSString *)identifier;
- (NSObject *)getObjectWithIdentifier:(NSString *)identifier;


@end
