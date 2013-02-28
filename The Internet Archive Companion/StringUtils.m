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
//2010-07-06 22:50:45
NSString *const ArchiveMetaDateFormat = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss";
//2010-07-06
NSString *const ArchiveMetaDayFormat = @"yyyy'-'MM'-'dd";



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


+ (NSString *) displayDateFromArchiveDayString:(NSString *)metaDate{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = ArchiveMetaDayFormat;
    NSDate *sDate = [dateFormatter dateFromString:metaDate];
    
    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:DisplayDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];
    
    return theDate;
}



+ (NSString *) displayDateFromArchiveMetaDateString:(NSString *)metaDate{

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = ArchiveMetaDateFormat;
    NSDate *sDate = [dateFormatter dateFromString:metaDate];
    
    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:DisplayDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];
    
    return theDate;
}


+ (NSString *) stringFromObject:(NSObject *)object{
    if([object isKindOfClass:[NSArray class]]){
        NSMutableString * subs = [[NSMutableString alloc] init];
        for (NSObject * obj in (NSArray*)object)
        {
            if(![subs isEqualToString:@""]){
                [subs appendString:@", "];
            }
            if([obj isKindOfClass:[NSString class]]){
                [subs appendString:(NSString *)obj];
            } else {
                return nil;
            }
            
        }
        
        return subs;
        
    } else if([object isKindOfClass:[NSString class]]) {
        if([StringUtils displayDateFromArchiveDayString:(NSString*)object]){
            return [StringUtils displayDateFromArchiveDayString:(NSString*)object];
        } else if([StringUtils displayDateFromArchiveDateString:(NSString*)object]){
            return [StringUtils displayDateFromArchiveDateString:(NSString*)object];
        } else if([StringUtils displayDateFromArchiveMetaDateString:(NSString*)object]){
            return [StringUtils displayDateFromArchiveMetaDateString:(NSString*)object];
        } else {
            return (NSString *)object;
        }
    } else {
        return nil;
    }
}



+ (NSString *) decimalFormatNumberFromInteger:(int)input{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:input]];
    return formatted;

}


@end
