//
//  MediaUtils.h
//  IA
//
//  Created by Hunter on 2/21/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArchiveFile.h"

@interface MediaUtils : NSObject


+ (NSString *)iconStringFromFormat:(FileFormat)format;
+ (FileFormat)formatFromString:(NSString *)name;
+ (UIColor *)colorForFileFormat:(FileFormat)format;
@end
