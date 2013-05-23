//
//  ArchiveFile.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    FileFormatTxt = 11,
    
    FileFormat128KbpsMP3 = 12,
    FileFormatMP3 = 13,
    FileFormat96KbpsMP3 = 14
    
} FileFormat;



@interface ArchiveFile : NSObject

@property (nonatomic, strong) NSDictionary *file;
@property (nonatomic) FileFormat format;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) int track;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *directory;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *identifierTitle;
@property (nonatomic) int size;



- (id) initWithIdentifier:(NSString *)identifier withIdentifierTitle:(NSString *)identifierTitle withServer:(NSString *)server withDirectory:(NSString *)dir withFile:(NSDictionary *)file;


@end


