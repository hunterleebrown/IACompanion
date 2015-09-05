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

NSString *const ShortDateFormat = @"M/d/YYYY";


+ (NSString *) urlEncodeString:(NSString *)input{
    
    NSString *escapedString = (NSString *)CFBridgingRelease(
                                                            CFURLCreateStringByAddingPercentEscapes( NULL,
                                                                                                    (CFStringRef)input,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ",
                                                                                                    kCFStringEncodingISOLatin1));
    
    
    return escapedString;
}


+ (NSString *) stringByStrippingHTML:(NSString *)inString {
    if (inString == nil) return @"";
    
    NSRange r;
    NSString *s = [inString copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    return s;
}


+ (NSString *) htmlStringByAddingBreaks:(NSString *)html {
    
    NSRange r;
    NSString *s = [html copy];
    if((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        
        while ((r = [s rangeOfString:@"\n" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@"<br/>"];
        }

        while ((r = [s rangeOfString:@"\n\n" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@"<br/>"];
        }

        while ((r = [s rangeOfString:@"<br/><br/>" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@"<br/>"];
        }

        while ((r = [s rangeOfString:@"<br><br/>" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@"<br/>"];
        }
        
        while ((r = [s rangeOfString:@"</p><br/>" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@"</p>"];
        }
        
        while ((r = [s rangeOfString:@"</p>\n</p>" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@"</p>"];
        }
        
        
        //
//        while ((r = [s rangeOfString:@"</br></br>" options:NSRegularExpressionSearch]).location != NSNotFound)
//        {
//            s = [s stringByReplacingCharactersInRange:r withString:@"</br>"];
//        }

        return s;
        
    } else
    {
        return [html stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    }
    
}


+ (NSString *) displayShortDateFromArchiveDateString:(NSString *)archiveInDate {
    NSDateFormatter *dateFormatter = [self.class dateFormatter];

    dateFormatter.dateFormat = ArchiveDateFormat;
    NSDate *sDate = [dateFormatter dateFromString:archiveInDate];

    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:ShortDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];

    return theDate;
}


+ (NSString *) displayDateFromArchiveDateString:(NSString *)archiveInDate {
    NSDateFormatter *dateFormatter = [self.class dateFormatter];
    
    dateFormatter.dateFormat = ArchiveDateFormat;
    NSDate *sDate = [dateFormatter dateFromString:archiveInDate];
    
    if(!sDate)
    {
        dateFormatter.dateFormat = ArchiveMetaDateFormat;
        sDate = [dateFormatter dateFromString:archiveInDate];
    }
    
    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:DisplayDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];
    
    return theDate;
}


+ (NSString *) displayDateFromArchiveDayString:(NSString *)metaDate{
    
    NSDateFormatter *dateFormatter = [self.class dateFormatter];
    
    dateFormatter.dateFormat = ArchiveMetaDayFormat;
    NSDate *sDate = [dateFormatter dateFromString:metaDate];
    
    NSDateFormatter *showDateFormat = [NSDateFormatter new];
    [showDateFormat setDateFormat:DisplayDateFormat];
    NSString *theDate = [showDateFormat stringFromDate:sDate];
    
    return theDate;
}



+ (NSString *) displayDateFromArchiveMetaDateString:(NSString *)metaDate{

    NSDateFormatter *dateFormatter = [self.class dateFormatter];
    
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



+ (NSString *) decimalFormatNumberFromInteger:(NSInteger)input{
    NSNumberFormatter *formatter = [self numberFormatter];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    NSNumber *numInt = [NSNumber numberWithInteger:input];

    if(input > 1000000)
    {
        NSNumber *calcNum = [NSNumber numberWithInteger:input / 1000000];
        return [NSString stringWithFormat:@"%@M", [calcNum stringValue]];
    }

    NSString *formatted = [formatter stringFromNumber:numInt];
    return formatted;

}




+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    
    return dateFormatter;
}


+ (NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *numberFormatter;
    
    if (!numberFormatter)
    {
        numberFormatter = [NSNumberFormatter new];
    }
    
    return numberFormatter;
}

@end
