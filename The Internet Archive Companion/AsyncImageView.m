//
//  AsyncImageView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/26/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "AsyncImageView.h"

@implementation AsyncImageView

static NSCache *cache = nil;
static NSOperationQueue *queue = nil;



/* We use a single NSCache for all instances of ImageFile.  The count limit is set to a value that allows demonstrating the cache evicting objects.
 */
+ (void)initialize {
    if (self == [AsyncImageView class]) {
        cache = [[NSCache alloc] init];
        [cache setCountLimit:100];
        queue = [NSOperationQueue new];
    
    }
}


+ (NSCache *)cache {
    return cache;
}

/* In case we want to have a per-instance cache.
 */
- (NSCache *)cache {
    return cache;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:spinner];


    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:spinner];
    }
    return self;
}


- (void) layoutSubviews{
    [super layoutSubviews];
    spinner.center = CGPointMake(self.center.x, self.center.y);

}

- (void)setAndLoadImageFromUrl:(NSString *)url{
    
    imageUrl = url;

    
   // NSLog(@"---------> imageUrl in: %@", imageUrl);

    
    spinner.center = CGPointMake(self.center.x, self.center.y);
    [spinner startAnimating];
    id cI = [cache objectForKey:imageUrl];
    if(cI != nil){
        UIImage *cachedImage = (UIImage *)cI;
        [self displayImage:cachedImage];
     //   NSLog(@"CACHE HIT...");
    } else {
      //  NSLog(@"NO CACHE HIT...");

        //NSOperationQueue *queue = [NSOperationQueue new];
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
  //  NSLog(@"---------> loaded ImageUrl: %@", imageUrl);


}


@end
