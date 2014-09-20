//
//  ArchiveSearchItem.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveFile.h"
#import "ArchiveImage.h"

typedef enum {
    MediaTypeNone = 0,
    MediaTypeAudio = 1,
    MediaTypeVideo = 2,
    MediaTypeTexts = 3,
    MediaTypeImage = 4,
    MediaTypeCollection = 5,
    MediaTypeAny = 6
    
}MediaType;

@interface ArchiveSearchDoc : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *headerImageUrl;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *publicDate;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSDictionary *rawDoc;
@property (strong, nonatomic) ArchiveImage *archiveImage;
@property (assign) MediaType type;


@end



@interface ArchiveDetailDoc : ArchiveSearchDoc


@property (strong, nonatomic) NSString *uploader;
@property (strong, nonatomic) NSString *creator;
@property (assign) MediaType type;
@property (strong, nonatomic) NSArray *files;

@end