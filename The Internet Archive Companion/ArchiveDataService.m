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

/*
 
 http://archive.org/advancedsearch.php?
 q=mediatype:collection+
 AND+NOT+hidden:true+
 AND+collection:movies
 &fl[]=headerImage
 &fl[]=identifier
 &fl[]=title
 &sort[]=titleSorter+asc&sort[]=
 &sort[]=
 &rows=50
 &page=1
 &output=json
 
 
*/


- (void) setAndLoadDataFromJSONUrl:(NSString *)url{
    //inUrl = @"http://archive.org/advancedsearch.php?q=mediatype:collection+AND+NOT+hidden:true+AND+collection:movies&fl[]=headerImage&fl[]=identifier&fl[]=title&sort[]=titleSorter+asc&sort[]=&sort[]=&rows=50&page=1&output=json";
    
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


/* specific implementation */
- (void) getCollectionsWithType:(MediaType)type WithName:(NSString *)name{
    NSString *t = @"";
    if(type == MediaTypeAudio){
        t = @"audio";
    } else if(type == MediaTypeVideo){
        t = @"movies";
    } else if(type == MediaTypeTexts){
        t = @"texts";
    } else if(type == MediaTypeCollection){
        t = @"collection";
    }
    
    NSString *test = @"http://archive.org/advancedsearch.php?q=mediatype:%@+AND+NOT+hidden:true+AND+collection:%@&fl[]=headerImage&fl[]=identifier&fl[]=title&sort[]=titleSorter+asc&sort[]=&sort[]=&rows=50&page=1&output=json";

    NSString *searchUrl = [NSString stringWithFormat:test, t, name];

    
    
    
    
    //NSString *searchUrl = @"http://archive.org/advancedsearch.php?q=mediatype:collection+AND+NOT+hidden:true+AND+collection:movies&fl[]=headerImage&fl[]=identifier&fl[]=title&sort[]=titleSorter+asc&sort[]=&sort[]=&rows=50&page=1&output=json";
    
    
    NSLog(@"searchUrl: %@", searchUrl);

    
    [self setAndLoadDataFromJSONUrl:searchUrl];
    
    
}


- (void) getCollectionsWithName:(NSString *)name{
    NSString *test = @"http://archive.org/advancedsearch.php?q=mediatype:collection+AND+NOT+hidden:true+AND+collection:%@&fl[]=headerImage&fl[]=identifier&fl[]=title&sort[]=titleSorter+asc&sort[]=&sort[]=&rows=50&page=1&output=json";
    
    NSString *searchUrl = [NSString stringWithFormat:test, name];
    
    NSLog(@"searchUrl: %@", searchUrl);

    
    [self setAndLoadDataFromJSONUrl:searchUrl];

}










@end
