//
//  ArchiveImageView.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveImageView.h"

@implementation ArchiveImageView

@synthesize archiveImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        archiveImage = [[ArchiveImage alloc] init];
        [archiveImage addObserver:self forKeyPath:@"downloaded" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        archiveImage = [[ArchiveImage alloc] init];
        [archiveImage addObserver:self forKeyPath:@"downloaded" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}


- (id)initWithArchiveImage:(ArchiveImage *)image {
    self = [super initWithImage:image.contentImage];
    if (self) {
        self.archiveImage = image;

    }
    return self;
}

- (id)initWithUIImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        ArchiveImage *i = [ArchiveImage new];
        i.contentImage = image;
        self.archiveImage = i;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame archiveImage:(ArchiveImage *)image {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.archiveImage = image;
        [archiveImage addObserver:self forKeyPath:@"downloaded" options:NSKeyValueObservingOptionNew context:NULL];

    }
    
    return self;
}


- (void) setArchiveImage:(ArchiveImage *)newImage {

    if (archiveImage != newImage) {
        self.image = nil;
    
        [archiveImage removeObserver:self forKeyPath:@"downloaded"];
        archiveImage = newImage;
        [archiveImage addObserver:self forKeyPath:@"downloaded" options:NSKeyValueObservingOptionNew context:NULL];
        
        if (archiveImage.downloaded) {
            [self updateImage:newImage];
        }
        else {
            [archiveImage startDownloading];
        }
    }
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
}

- (void)updateImage:(ArchiveImage *)img {
    self.image = img.contentImage;
}

#pragma mark - Download Handlers

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"downloaded"]) {
        BOOL downloaded = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (downloaded) {
            [self updateImage:archiveImage];
        }
    }
}


- (void) dealloc{
    @try{
        [archiveImage removeObserver:self forKeyPath:@"downloaded"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }}

@end

