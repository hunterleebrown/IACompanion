//
//  ArchiveSearchItem.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveSearchDoc.h"

@implementation ArchiveSearchDoc



- (NSString *)creator
{
    NSObject *creat = [self.rawDoc valueForKey:@"creator"];
    if([creat isKindOfClass:[NSArray class]])
    {
        return [((NSArray *)creat) objectAtIndex:0];
    } else
    {
        if([creat isKindOfClass:[NSNull class]])
        {
            return  nil;
        } else
        {
            return (NSString *)creat;
        }
    }
}



@end




@implementation ArchiveDetailDoc

- (NSString *)creator
{
    NSObject *creat = [self.rawDoc valueForKeyPath:@"metadata.creator"];
    if([creat isKindOfClass:[NSArray class]])
    {
        return [((NSArray *)creat) objectAtIndex:0];
    } else
    {
        if([creat isKindOfClass:[NSNull class]])
        {
            return  nil;
        } else
        {
            return (NSString *)creat;
        }
    }
}

@end