//
//  MediaUtils.m
//  IA
//
//  Created by Hunter on 2/21/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "MediaUtils.h"
#import "FontMapping.h"
#import "ArchiveSearchDoc.h"

@implementation MediaUtils




+ (NSString *)iconStringFromMediaType:(MediaType)type
{
    switch (type) {
        case MediaTypeAudio:
            return AUDIO;
            break;

        case MediaTypeCollection:
            return COLLECTION;
            break;

        case MediaTypeImage:
            return IMAGE;
            break;

        case MediaTypeTexts:
            return BOOK;
            break;

        case MediaTypeVideo:
            return VIDEO;
            break;

        case MediaTypeAny:
            return ARCHIVE;
            break;

        case MediaTypeSoftware:
            return SOFTWARE;
            break;

        default:
            return ARCHIVE;
            break;
    }

}


+ (UIColor *)colorFromMediaType:(MediaType)type
{
    switch (type) {
        case MediaTypeAudio:
            return AUDIO_COLOR;
            break;

        case MediaTypeCollection:
            return COLLECTION_COLOR;
            break;

        case MediaTypeImage:
            return IMAGE_COLOR;
            break;

        case MediaTypeTexts:
            return BOOK_COLOR;
            break;

        case MediaTypeVideo:
            return VIDEO_COLOR;
            break;

        case MediaTypeSoftware:
            return SOFTWARE_COLOR;
            break;

        case MediaTypeAny:
            return [UIColor blackColor];
            break;

        default:
            return [UIColor blackColor];
            break;
    }
    
}

+ (NSString *)iconStringFromFormat:(FileFormat)format
{
    switch (format) {
        case FileFormatH264:
            return VIDEO;
            break;
        case FileFormatMPEG4:
            return VIDEO;
            break;
        case FileFormat512kbMPEG4:
            return VIDEO;
            break;
        default:
            return AUDIO;
            break;
    }
}

+ (UIColor *)colorForFileFormat:(FileFormat)format
{
    switch (format) {
        case FileFormatH264:
            return VIDEO_COLOR;
            break;
        case FileFormatMPEG4:
            return VIDEO_COLOR;
            break;
        case FileFormat512kbMPEG4:
            return VIDEO_COLOR;
            break;

        case FileFormatJPEG:
            return IMAGE_COLOR;
            break;

        case FileFormatGIF:
            return IMAGE_COLOR;
            break;

        case FileFormatProcessedJP2ZIP:
            return BOOK_COLOR;
            break;

        case FileFormatH264HD:
            return VIDEO_COLOR;
            break;


        case FileFormatDjVuTXT:
            return BOOK_COLOR;
            break;

        case FileFormatTxt:
            return BOOK_COLOR;
            break;


        case FileFormatVBRMP3:
            return AUDIO_COLOR;
            break;


        case FileFormat128KbpsMP3:
            return AUDIO_COLOR;
            break;

        case FileFormatMP3:
            return AUDIO_COLOR;
            break;

        case FileFormat96KbpsMP3:
            return AUDIO_COLOR;
            break;

        default:
            return [UIColor blackColor];
            break;
    }
}

+ (FileFormat)formatFromString:(NSString *)name
{

    FileFormat format;
    if(name){

        if([name isEqualToString:@"VBR MP3"]){
            format = FileFormatVBRMP3;
        } else if([name isEqualToString:@"h.264"]){
            format = FileFormatH264;
        } else if([name isEqualToString:@"MPEG4"]){
            format = FileFormatMPEG4;
        } else if([name isEqualToString:@"512Kb MPEG4"]){
            format = FileFormat512kbMPEG4;
        } else if ([name isEqualToString:@"128Kbps MP3"]){
            format = FileFormat128KbpsMP3;
        } else if([name isEqualToString:@"MP3"]){
            format = FileFormatMP3;
        } else if([name isEqualToString:@"96Kbps MP3"]) {
            format = FileFormat96KbpsMP3;
        } else if([name isEqualToString:@"JPEG"]){
            format = FileFormatJPEG;
        } else if([name isEqualToString:@"GIF"]){
            format = FileFormatGIF;
        } else if([name isEqualToString:@"64Kbps MP3"]){
            format = FileFormat64KbpsMP3;
        } else if ([name isEqualToString:@"h.264 HD"]){
            format = FileFormatH264HD;
        } else if([name isEqualToString:@"Single Page Processed JP2 ZIP"]){
            format = FileFormatProcessedJP2ZIP;
        } else if([name isEqualToString:@"DjVuTXT"]){
            format = FileFormatDjVuTXT;
        } else if([name isEqualToString:@"Text"]){
            format = FileFormatTxt;
        }
        else {
            format = FileFormatOther;
        }

    } else {
        format = FileFormatOther;
    }
    return format;
}

@end
