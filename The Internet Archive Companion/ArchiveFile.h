//
//  ArchiveFile.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveDataService.h"

typedef enum {
    FileFormatOther = 0,
    FileFormatVBRMP3 = 1,
    FileFormatH264 = 2,
    FileFormatMPEG4 = 3,
    FileFormat512kbMPEG4 = 4
    
} FileFormat;



@interface ArchiveFile : NSObject

@property (nonatomic, assign) NSDictionary *file;
@property (nonatomic) FileFormat format;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *track;
@property (nonatomic, assign) NSString *url;
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) NSString *server;
@property (nonatomic, assign) NSString *directory;
@property (nonatomic, assign) NSString *height;
@property (nonatomic, assign) NSString *width;



- (id) initWithIdentifier:(NSString *)identifier withServer:(NSString *)server withDirectory:(NSString *)dir withFile:(NSDictionary *)file;


@end


