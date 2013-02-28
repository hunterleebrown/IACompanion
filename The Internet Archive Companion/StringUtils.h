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
+ (NSString *) decimalFormatNumberFromInteger:(int)input;

@end
