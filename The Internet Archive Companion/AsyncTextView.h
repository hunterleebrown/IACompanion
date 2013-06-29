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
    int startByte;
    int readLength;

}

+ (NSCache *)cache;
+ (NSOperationQueue *)queue;
- (void) setAndLoadViewFromUrl:(NSString *)url withStartByte:(int)start withLength:(int)length;


@end
