//
//  StringUtils.h
//  The Internet Archive Companion
//
//  Created by Hunter Brown on 2/8/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject


+ (NSString *) urlEncodeString:(NSString *)input;
+ (NSString *) displayDateFromArchiveDateString:(NSString *)archiveInDate;
+ (NSString *) displayDateFromArchiveMetaDateString:(NSString *)metaDate;
+ (NSString *) displayDateFromArchiveDayString:(NSString *)metaDate;
+ (NSString *) stringFromObject:(NSObject *)object;
+ (NSString *) decimalFormatNumberFromInteger:(NSInteger)input;
+ (NSString *) timeFormatted:(NSInteger)totalSecond;
+ (NSString *) stringByStrippingHTML:(NSString *)inString;
+ (NSString *) displayShortDateFromArchiveDateString:(NSString *)archiveInDate;

+ (NSString *) htmlStringByAddingBreaks:(NSString *)html;

@end
