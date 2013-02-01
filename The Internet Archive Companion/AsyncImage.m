//
//  AsyncImage.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/1/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "AsyncImage.h"

@implementation AsyncImage

- (id) init{
    self = [super init];
    if(self){
        cache = [[NSCache alloc] init];
       
    }
    return self;
}


- (void)setAndLoadImageFromUrl:(NSString *)url{
    imageUrl = url;
    
    id cI = [cache objectForKey:imageUrl];
    if(cI != nil){
        UIImage *cachedImage = (UIImage *)cI;
        self.image = cachedImage;
        NSLog(@"CACHE HIT...");
    } else {
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadImage)
                                            object:nil];
        [queue addOperation:operation];
    }
    
    
    
}

- (void)loadImage {
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [cache setObject:image forKey:imageUrl];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

@end
