//
//  AsyncTextView.h
//  IA
//
//  Created by Hunter Brown on 2/28/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncTextView : UITextView {
    NSString *fileUrl;
    UIActivityIndicatorView *spinner;
    NSInteger startByte;
    NSInteger readLength;

}

+ (NSCache *)cache;
- (void) setAndLoadViewFromUrl:(NSString *)url withStartByte:(NSInteger)start withLength:(NSInteger)length;


@end
