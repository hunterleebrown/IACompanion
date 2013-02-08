//
//  StringUtils.m
//  The Internet Archive Companion
//
//  Created by Hunter Brown on 2/8/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

NSString *const DisplayDateFormat = @"MMMM d, YYYY";
//2002-07-16T00:00:00Z
NSString *const ArchiveDateFormat = @"yyyy'-'MM'-'dd'T'HH:mm:ss'Z'";



+ (NSString *) urlEncodeString:(NSString *)input{
    
    NSString *escapedString = (NSString *)CFBridgingRelease(
                                                            CFURLCreateStringByAddingPercentEscapes( NULL,
                                                                                                    (CFStringRef)input,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ",
                                                                                                    kCFStringEncodingISOLatin1));
    
    
    return escapedString;
}




+ (NSString *) displayDateFromArchiveDateString:(NSString *)archiveInDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = ArchiveDateFormat;
    NSDate *sDate = [dateFormatter dateFromString:archiveInDate];
    
    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:DisplayDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];
    
    return theDate;
}


@end
