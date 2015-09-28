//
//  SimpleCache.m
//  IA
//
//  Created by Hunter on 9/27/15.
//  Copyright © 2015 Hunter Lee Brown. All rights reserved.
//

#import "SimpleCache.h"

@implementation SimpleCache


static SimpleCache *simpleCache;
static NSInteger cacheLimit = 3;

+ (SimpleCache *)sharedInstance
{
    if(!simpleCache)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            simpleCache = [[SimpleCache alloc] init];;
        });
    }
    return simpleCache;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.keys = [NSMutableArray new];
        self.dictionary = [NSMutableDictionary new];
    }
    return self;
}

- (void)addItem:(NSObject *)object withIdentifier:(NSString *)identifier
{
    
    if([self.dictionary objectForKey:identifier] != nil)
    {
        [self.dictionary setObject:object forKey:identifier];
        [self debugPrint];
        return;
    }
    
    
    if(self.dictionary.count >= cacheLimit)
    {
        NSString *k = [self.keys objectAtIndex:0];
        [self.dictionary removeObjectForKey:k];
        [self.keys removeObjectAtIndex:0];
        
    }
    [self.keys addObject:identifier];
    [self.dictionary setObject:object forKey:identifier];

    
    [self debugPrint];


}

- (void)debugPrint
{
    NSLog(@"-----> SimpleCache total items: %lu", self.dictionary.count);
    NSLog(@"-----> SimpleCache tems: %@", self.keys);
}

- (void)removeItemWithIdentifier:(NSString *)identifier
{
    if([self.keys containsObject:identifier]){
        [self.keys removeObject:identifier];
        [self.dictionary removeObjectForKey:identifier];
    }
    
    [self debugPrint];
    
}

- (NSObject *)getObjectWithIdentifier:(NSString *)identifier
{
    if([self.dictionary objectForKey:identifier] == nil)
    {
        return nil;
    }
    
    NSInteger index = [self.keys indexOfObject:identifier];
    [self.keys removeObjectAtIndex:index];
    [self.keys addObject:identifier];
    
    [self debugPrint];
    
    return [self.dictionary objectForKey:identifier];
}




@end
