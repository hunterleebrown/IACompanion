//
//  ArchiveDataService.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDataService.h"

@implementation ArchiveDataService
@synthesize delegate;

- (void)setAndLoadDataFromJSONUrl:(NSString *)url{
    inUrl = url;
    
    id cI = [cache objectForKey:inUrl];
    if(cI != nil){
        NSDictionary *cachedData = (NSDictionary *)cI;
        [self sendData:cachedData];
        NSLog(@"CACHE HIT...");
    } else {
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadData)
                                            object:nil];
        [queue addOperation:operation];
    }
    
    
    
}

- (void)loadData {
    NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inUrl]];
    NSError *jsonParsingError = nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    [cache setObject:json forKey:inUrl];
    [self performSelectorOnMainThread:@selector(sendData:) withObject:json waitUntilDone:NO];
}




- (void)sendData:(NSDictionary *)inData {
    if(delegate && [delegate respondsToSelector:@selector(dataDidFinishLoadingWithDictionary:)]){
        [delegate dataDidFinishLoadingWithDictionary:inData];
    }

}


@end
