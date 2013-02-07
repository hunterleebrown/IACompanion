//
//  ArchiveDataService.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDataService.h"
#import "ArchiveSearchDoc.h"

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
    
    NSMutableDictionary *rawResults = [NSMutableDictionary new];
    [rawResults setObject:inData forKey:@"original"];
    NSMutableArray *responseDocs = [NSMutableArray new];
    
    NSDictionary *response = [inData objectForKey:@"response"];
    NSDictionary *metadata = [inData objectForKey:@"metadata"];

    
    if(response){
        NSArray *docs = [response objectForKey:@"docs"];
        if(docs){
            for(NSDictionary *doc in docs){
                if([doc objectForKey:@"description"] && [doc objectForKey:@"title"]){
                    ArchiveSearchDoc *aDoc = [ArchiveSearchDoc new];
                    [aDoc setRawDoc:doc];
                    [aDoc setIdentifier:[doc objectForKey:@"identifier"]];
                    [aDoc setTitle:[doc objectForKey:@"title"]];
                    
                    if(![doc objectForKey:@"headerImage"]){
                        [aDoc setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", aDoc.identifier]];
                    } else {
                        [aDoc setHeaderImageUrl:[doc objectForKey:@"headerImage"]];
                    }
                    [aDoc setDescription:[doc objectForKey:@"description"]];
                    [aDoc setPublicDate:[doc objectForKey:@"publicdate"]];
                    [aDoc setDate:[doc objectForKey:@"date"]];
                    
                    [responseDocs addObject:aDoc];
                }
            
            }
            [rawResults setObject:responseDocs forKey:@"documents"];
            [rawResults setObject:[response objectForKey:@"numFound"] forKey:@"numFound"];
        }
    }
    
    if(metadata){
        ArchiveDetailDoc *dDoc = [ArchiveDetailDoc new];
        [dDoc setRawDoc:inData];
        NSDictionary *metadata = [inData objectForKey:@"metadata"];
        [dDoc setIdentifier:[metadata objectForKey:@"identifier"]];
        [dDoc setTitle:[metadata objectForKey:@"title"]];
        if(![metadata objectForKey:@"headerImage"]){
            [dDoc setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", dDoc.identifier]];
        } else {
            [dDoc setHeaderImageUrl:[metadata objectForKey:@"headerImage"]];
        }
        [dDoc setDescription:[metadata objectForKey:@"description"]];
        [dDoc setPublicDate:[metadata objectForKey:@"publicdate"]];
        
        [responseDocs addObject:dDoc];
        
        [rawResults setObject:responseDocs forKey:@"documents"];
    
    }
    
    
    if(delegate && [delegate respondsToSelector:@selector(dataDidFinishLoadingWithDictionary:)]){
        [delegate dataDidFinishLoadingWithDictionary:rawResults];
    }

}


/* specific implementation */
- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier withSort:(NSString *)sort withStart:(NSString *)start{
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
    
    NSString *test = @"http://archive.org/advancedsearch.php?q=mediatype:%@+AND+NOT+hidden:true+AND+collection:%@&sort[]=%@&sort[]=&sort[]=&rows=50&page=1&output=json&start=%@";
    NSString *searchUrl = [NSString stringWithFormat:test, t, identifier, sort, start];
    NSLog(@"searchUrl: %@", searchUrl);
    [self setAndLoadDataFromJSONUrl:searchUrl];

}

- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier{
    [self getDocsWithType:type withIdentifier:identifier withSort:@"publicdate+desc" withStart:@"0"];
}


- (void) getCollectionsWithIdentifier:(NSString *)identifier{
    [self getDocsWithType:MediaTypeCollection withIdentifier:identifier withSort:@"titleSorter+asc" withStart:@"0"];
}


- (void) getMetadataDocsWithIdentifier:(NSString *)identifier{
    NSString *test = @"http://archive.org/metadata/%@";
    NSString *searchUrl = [NSString stringWithFormat:test, identifier];
    NSLog(@"searchUrl: %@", searchUrl);
    [self setAndLoadDataFromJSONUrl:searchUrl];
}







@end
