//
//  AsyncTextView.m
//  IA
//
//  Created by Hunter Brown on 2/28/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "AsyncTextView.h"

@implementation AsyncTextView

static NSCache *cache = nil;
static NSOperationQueue *queue = nil;



/* We use a single NSCache for all instances of ImageFile.  The count limit is set to a value that allows demonstrating the cache evicting objects.
 */
+ (void)initialize {
    if (self == [AsyncTextView class]) {
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
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:spinner];
        
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:spinner];
    }
    return self;
}


- (void) layoutSubviews{
    [super layoutSubviews];
    spinner.center = CGPointMake(self.center.x, self.center.y);
    
}

- (void) setAndLoadViewFromUrl:(NSString *)url withStartByte:(NSInteger)start withLength:(NSInteger)length {
    fileUrl = url;
    startByte = start;
    readLength = length;
    
   // NSLog(@"---------> imageUrl in: %@", fileUrl);
    
    
    spinner.center = CGPointMake(self.center.x, self.center.y);
    [spinner startAnimating];
    id cD = [cache objectForKey:fileUrl];
    if(cD != nil){
        NSData *cachedData = (NSData *)cD;
        [self displayView:cachedData];
        NSLog(@"CACHE HIT...");
    } else {
        NSLog(@"NO CACHE HIT...");
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadData)
                                            object:nil];
        [queue addOperation:operation];
    }
    
    
    
}




- (void)loadData {
    NSData* fileData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fileUrl]];
    
    NSString *results = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];

    results = [results stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<--GURTENPARAGRAPH-->"];
    results = [results stringByReplacingOccurrencesOfString:@"\n\n" withString:@"<--PARAGRAPH-->"];
    results = [results stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    results = [results stringByReplacingOccurrencesOfString:@"<--PARAGRAPH-->" withString:@"\n\n"];
    results = [results stringByReplacingOccurrencesOfString:@"<--GURTENPARAGRAPH--><--GURTENPARAGRAPH-->" withString:@"\n\n"];
    results = [results stringByReplacingOccurrencesOfString:@"<--GURTENPARAGRAPH-->" withString:@""];

    
    NSData *munge = [results dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [cache setObject:munge forKey:fileUrl];
    [self performSelectorOnMainThread:@selector(displayView:) withObject:munge waitUntilDone:NO];
    
    
    
}

- (void)displayView:(NSData *)inData {
    NSRange range = NSMakeRange(startByte, readLength);
    
    NSInteger dataLength = inData.length;
    if(startByte > dataLength) {
        [self setText:@"[--- RAN OUT OF FILE ---]"];
        [spinner stopAnimating];
        return;
    }
    if(dataLength < (startByte + readLength)){
        NSInteger difference = dataLength - startByte;
        if(difference < 0){
            [self setText:@"[--- RAN OUT OF FILE ---]"];
            return;
        }
        range = NSMakeRange(startByte, difference);
    }
    
    
    NSString *textValue = [[NSString alloc] initWithData:[inData subdataWithRange:range] encoding:NSUTF8StringEncoding];
    [self setText:textValue];
    [spinner stopAnimating];
    
    
}


/*

- (void)loadData {
    NSData* fileData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:fileUrl]];
    
    NSString *results = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    results = [results stringByReplacingOccurrencesOfString:@"\n\n" withString:@"<--PARAGRAPH-->"];
    results = [results stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //results = [results stringByReplacingOccurrencesOfString:@"<--PARAGRAPH-->" withString:@"\n\n"];
    
    NSData *munge = [results dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [cache setObject:munge forKey:fileUrl];
    [self performSelectorOnMainThread:@selector(displayView:) withObject:munge waitUntilDone:NO];
    
    
    
}

- (void)displayView:(NSData *)inData {
    NSRange range = NSMakeRange(startByte, readLength);

    //NSString *textValue = [[NSString alloc] initWithData:[inData subdataWithRange:range] encoding:NSUTF8StringEncoding];
    
    NSString *text = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [text componentsSeparatedByCharactersInSet:separators];
    NSMutableString *sendValue = [NSMutableString new];
    
    
    NSArray *itemsForView = [words subarrayWithRange:range];

    
    for(NSString *st in itemsForView){
        NSString *results = [st stringByReplacingOccurrencesOfString:@"<--PARAGRAPH-->" withString:@"\n\n"];
        [sendValue appendString:[NSString stringWithFormat:@"%@ ", results]];
    }
    
    [self setText:sendValue];
    [spinner stopAnimating];
    //  NSLog(@"---------> loaded ImageUrl: %@", imageUrl);
    
    
} */


@end
