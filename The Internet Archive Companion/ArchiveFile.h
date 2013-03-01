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
    FileFormat512kbMPEG4 = 4,
    
    FileFormatJPEG = 5,
    FileFormatGIF = 6,
    FileFormatProcessedJP2ZIP = 7,
    FileFormat64KbpsMP3 = 8,
    FileFormatH264HD = 9,
    
    FileFormatDjVuTXT = 10,
    FileFormatTxt = 11
    
} FileFormat;



@interface ArchiveFile : NSObject

@property (nonatomic, assign) NSDictionary *file;
@property (nonatomic) FileFormat format;
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) int track;
@property (nonatomic, assign) NSString *url;
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) NSString *server;
@property (nonatomic, assign) NSString *directory;
@property (nonatomic, assign) NSString *height;
@property (nonatomic, assign) NSString *width;
@property (nonatomic, assign) NSString *identifierTitle;
@property (nonatomic, assign) int size;



- (id) initWithIdentifier:(NSString *)identifier withIdentifierTitle:(NSString *)identifierTitle withServer:(NSString *)server withDirectory:(NSString *)dir withFile:(NSDictionary *)file;


@end


