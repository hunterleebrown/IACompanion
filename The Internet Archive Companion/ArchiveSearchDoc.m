//
//  ArchiveSearchItem.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveSearchDoc.h"

@implementation ArchiveSearchDoc

- (id) init{

    self = [super init];
    if(self){
        cache = [[NSCache alloc] init];
    }
    return self;

}







@end
