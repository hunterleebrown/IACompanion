//
//  StringUtils.m
//  The Internet Archive Companion
//
//  Created by Hunter Brown on 2/8/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils



+ (NSString *)urlEncodeString:(NSString *)input{
    
    NSString *escapedString = (NSString *)CFBridgingRelease(
                                                            CFURLCreateStringByAddingPercentEscapes( NULL,
                                                                                                    (CFStringRef)input,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ",
                                                                                                    kCFStringEncodingISOLatin1));
    
    
    return escapedString;
}

@end
