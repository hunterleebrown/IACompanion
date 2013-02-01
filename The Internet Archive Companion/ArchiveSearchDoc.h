//
//  ArchiveSearchItem.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveSearchDoc : NSObject {
    NSCache *cache;


}

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *headerImageUrl;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *publicDate;


@end
