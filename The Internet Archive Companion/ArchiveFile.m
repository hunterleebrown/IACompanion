//
//  ArchiveFile.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/6/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveFile.h"

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
    if([[file objectForKey:@"format"] isEqualToString:@"VBR MP3"]){
        _format = FileFormatVBRMP3;
    } else if([[file objectForKey:@"format"] isEqualToString:@"h.264"]){
        _format = FileFormatH264;
    }
    
    if([file objectForKey:@"title"]){
        _title = [file objectForKey:@"title"];
    } else {
        _title = [file objectForKey:@"name"];
    }
    
    _track = [file objectForKey:@"track"];
    _name = [file objectForKey:@"name"];

    
}

- (NSString *) url{

    return [NSString stringWithFormat:@"http://%@%@/%@", _server, _directory, _name];

}



@end
