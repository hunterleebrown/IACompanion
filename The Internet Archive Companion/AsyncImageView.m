//
//  AsyncImageView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/26/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "AsyncImageView.h"

@implementation AsyncImageView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        cache = [[NSCache alloc] init];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:spinner];

    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        cache = [[NSCache alloc] init];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:spinner];
    }
    return self;
}


- (void)setAndLoadImageFromUrl:(NSString *)url{
    imageUrl = url;
    spinner.center = CGPointMake(self.center.x, self.center.y);
    [spinner startAnimating];
    id cI = [cache objectForKey:imageUrl];
    if(cI != nil){
        UIImage *cachedImage = (UIImage *)cI;
        [self displayImage:cachedImage];
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
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)inImage {
    [self setImage:inImage];
    [spinner stopAnimating];
}


@end
