//
//  AsyncImage.h
//  The Internet Archive Companion
//
//  Created by Hunter on 2/1/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImage : NSObject {
    NSString *imageUrl;
    NSCache *cache;

}

@property (nonatomic, retain) UIImage *image;

- (void) setAndLoadImageFromUrl:(NSString *)url;



@end
