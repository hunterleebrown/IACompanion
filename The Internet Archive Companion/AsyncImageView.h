//
//  AsyncImageView.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/26/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageView : UIImageView {
    NSString *imageUrl;
    NSCache *cache;
    UIActivityIndicatorView *spinner;
}

- (void) setAndLoadImageFromUrl:(NSString *)url;

@end

