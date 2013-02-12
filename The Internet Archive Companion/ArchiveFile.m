//
//  ArchiveFile.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveFile.h"
#import "StringUtils.h"

@implementation ArchiveFile


- (id) initWithIdentifier:(NSString *)identifier withServer:(NSString *)server withDirectory:(NSString *)dir withFile:(NSDictionary *)file{
    self= [super init];
    if(self){
        _identifier = identifier;
        _server = server;
        _directory = dir;
        [self setFile:file];
    }
    return self;

}

- (void) setFile:(NSDictionary *)file{
    _file = file;
    
    if([file objectForKey:@"format"]){
        
        if([[file objectForKey:@"format"] isEqualToString:@"VBR MP3"]){
            _format = FileFormatVBRMP3;
        } else if([[file objectForKey:@"format"] isEqualToString:@"h.264"]){
            _format = FileFormatH264;
        } else if([[file objectForKey:@"format"] isEqualToString:@"MPEG4"]){
            _format = FileFormatMPEG4;
        } else if([[file objectForKey:@"format"] isEqualToString:@"512Kb MPEG4"]){
            _format = FileFormat512kbMPEG4;
        }else if([[file objectForKey:@"format"] isEqualToString:@"JPEG"]){
            _format = FileFormatJPEG;
        } else if([[file objectForKey:@"format"] isEqualToString:@"GIF"]){
            _format = FileFormatGIF;
        }
        else {
            _format = FileFormatOther;
        }
        
    } else {
        _format = FileFormatOther;
    }
    
    if([file objectForKey:@"title"]){
        _title = [file objectForKey:@"title"];
    } else {
        _title = [file objectForKey:@"name"];
    }
    
    _track = [file objectForKey:@"track"];
    _name = [file objectForKey:@"name"];

    if([file objectForKey:@"height"]){
        _height = [file objectForKey:@"height"];
    }
    if([file objectForKey:@"width"]){
        _width = [file objectForKey:@"width"];
    }
}

- (NSString *) url{

    //return [NSString stringWithFormat:@"http://%@%@/%@", _server, _directory,[StringUtils urlEncodeString:_name]];
    return [NSString stringWithFormat:@"http://%@/%@/%@/%@", @"archive.org", @"download",_identifier, [StringUtils urlEncodeString:_name]];
    

}



@end
