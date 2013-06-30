//
//  ArchiveCache.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveCache.h"



@implementation ArchiveCache



+ (ArchiveCache *)sharedInstance {
    static dispatch_once_t onceToken;
    static ArchiveCache *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[ArchiveCache alloc] init];
        sSharedInstance.cache = [[NSCache alloc] init];
        [sSharedInstance.cache setCountLimit:300];
    });
    return sSharedInstance;
}

@end
