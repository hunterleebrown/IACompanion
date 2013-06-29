//
//  ArchiveDataService.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveDataService.h"
#import "ArchiveSearchDoc.h"
#import "StringUtils.h"
@interface ArchiveDataService () {

    NSString *identifierIn;
    NSString *fileNameIn;
    NSMutableURLRequest *bookTextPageRequest;
    NSMutableData *bookTextData;
}

@end


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

- (id) init{
    self = [super init];
    if(self){
        loadMoreStart = @"0";
        queue = [NSOperationQueue new];

    }
    return self;
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
                    
                    if([[doc objectForKey:@"mediatype"] isEqualToString:@"collection"]){
                        [aDoc setType:MediaTypeCollection];
                    } else if([[doc objectForKey:@"mediatype"] isEqualToString:@"audio"]){
                        [aDoc setType:MediaTypeAudio];
                    } else if([[doc objectForKey:@"mediatype"] isEqualToString:@"video"]){
                        [aDoc setType:MediaTypeVideo];
                    } else if([[doc objectForKey:@"mediatype"] isEqualToString:@"texts"]){
                        [aDoc setType:MediaTypeTexts];
                    } else {
                        [aDoc setType:MediaTypeAny];
                    }
                    
                    
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
        [dDoc setTitle:[StringUtils stringFromObject:[metadata objectForKey:@"title"]]];
        if(![metadata objectForKey:@"headerImage"]){
            [dDoc setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", dDoc.identifier]];
        } else {
            [dDoc setHeaderImageUrl:[metadata objectForKey:@"headerImage"]];
        }
        [dDoc setDescription:[metadata objectForKey:@"description"]];
        [dDoc setPublicDate:[metadata objectForKey:@"publicdate"]];
        
        NSMutableArray *files = [NSMutableArray new];
        if([inData objectForKey:@"files"]){
            for (NSDictionary *file in [inData objectForKey:@"files"]) {
                ArchiveFile *aFile = [[ArchiveFile alloc]initWithIdentifier:dDoc.identifier withIdentifierTitle:[StringUtils stringFromObject:dDoc.title] withServer:[inData objectForKey:@"server"] withDirectory:[inData objectForKey:@"dir"] withFile:file];
                [files addObject:aFile];
            }
        }
        [dDoc setFiles:files];
        
        
        
        [responseDocs addObject:dDoc];
        [rawResults setObject:responseDocs forKey:@"documents"];
    
    }
    
    if(identifierIn){
        [rawResults setObject:identifierIn forKey:@"identifier"];
    }
    
    
    if(fileNameIn) {
        ArchiveFile *aFile;
        ArchiveDetailDoc *aDoc = [responseDocs objectAtIndex:0];
        for(ArchiveFile *af in aDoc.files){
            if([af.name isEqualToString:fileNameIn]){
                aFile = af;
            }
        }
        if(aFile){
            
            
            if(delegate && [delegate respondsToSelector:@selector(dataDidFinishLoadingWithArchiveFile:)]){
                [delegate dataDidFinishLoadingWithArchiveFile:aFile];
            }
        }
        
        
        
    } else {
        
        if(delegate && [delegate respondsToSelector:@selector(dataDidFinishLoadingWithDictionary:)]){
            [delegate dataDidFinishLoadingWithDictionary:rawResults];
        }
    }
    
    

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
}






#pragma mark - the real request, async
- (void) setAndLoadDataFromJSONUrl:(NSString *)url{
    
    inUrl = url;
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadData)
                                        object:nil];
    [queue addOperation:operation];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    
}












- (void)loadData {
    

    
  //  NSLog(@"--->url: %@", inUrl);
    
    NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inUrl]];
    NSError *jsonParsingError = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    
    [self performSelectorOnMainThread:@selector(sendData:) withObject:json waitUntilDone:NO];
    
    
}



- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier withSort:(NSString *)sort{
    
    identifierIn = identifier;

    if(type != MediaTypeNone ){
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
        
        
        testUrl = @"http://archive.org/advancedsearch.php?q=mediatype:%@+AND+NOT+hidden:true+AND+collection:%@&sort[]=%@&sort[]=&sort[]=&rows=50&page=1&output=json";
        NSString *searchUrl = [NSString stringWithFormat:testUrl, t, identifier, sort];
        [self getDocsWithTest:searchUrl withStart:loadMoreStart];

    } else {
        testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@&sort[]=%@&sort[]=&sort[]=&rows=50&page=1&output=json";
        NSString *searchUrl = [NSString stringWithFormat:testUrl, identifier, sort];
        [self getDocsWithTest:searchUrl withStart:loadMoreStart];
    }
    

    
    
    
    //NSLog(@"searchUrl: %@", searchUrl);
    //[self setAndLoadDataFromJSONUrl:searchUrl];
    

}


#pragma mark - the outside world


- (void) getDocsWithType:(MediaType)type withIdentifier:(NSString *)identifier{
    [self getDocsWithType:type withIdentifier:identifier withSort:@"publicdate+desc"];
}

- (void) getDocsWithCollectionIdentifier:(NSString *)identifier{
    [self getDocsWithType:MediaTypeNone withIdentifier:identifier withSort:@"publicdate+desc"];
}

- (void) getStaffPicksDocsWithCollectionIdentifier:(NSString *)identifier {
    testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@+pick:1&rows=50&page=1&output=json";
    NSString *searchUrl = [NSString stringWithFormat:testUrl, identifier];
    [self getDocsWithTest:searchUrl withStart:loadMoreStart];

}


- (void) getCollectionsWithIdentifier:(NSString *)identifier{
    
    [self getDocsWithType:MediaTypeCollection withIdentifier:identifier withSort:@"titleSorter+asc"];
}



- (void) getDocsWithQueryString:(NSString *)query {
    NSString *realQuery = [NSString stringWithFormat:@"%@ AND NOT collection:web AND NOT collection:webwidecrawl", query];
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL,	 (CFStringRef)realQuery,	 NULL,	 (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingISOLatin1));
    testUrl = [NSString stringWithFormat:@"http://archive.org/advancedsearch.php?q=%@&output=json&rows=50", escapedString];
    [self getDocsWithTest:testUrl withStart:loadMoreStart];
}


- (void) getDocsWithQueryString:(NSString *)query forMediaType:(MediaType)type{
    NSString *t;

    switch (type) {
        case MediaTypeAudio:
            t = @"audio";
            break;
        case MediaTypeVideo:
            t = @"movies";
            break;
        case MediaTypeTexts:
            t = @"texts";
            break;
        case MediaTypeImage:
            t = @"image";
            break;
        case MediaTypeCollection:
            t = @"collection";
            break;
        case MediaTypeNone:
            break;
        default:
            break;
    }

    NSString *realQuery = [NSString stringWithFormat:@"%@ AND NOT collection:web AND NOT collection:webwidecrawl", query];
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL,	 (CFStringRef)realQuery,	 NULL,	 (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingISOLatin1));
    NSString *mediaTypeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL,	 (CFStringRef)[NSString stringWithFormat:@" AND mediatype:%@",t],	 NULL,	 (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingISOLatin1)); 
    testUrl = [NSString stringWithFormat:@"http://archive.org/advancedsearch.php?q=%@%@&output=json&rows=50", escapedString, [NSString stringWithFormat:@"%@", t ? mediaTypeString : @""]];
    [self getDocsWithTest:testUrl withStart:loadMoreStart];


}





- (void) getMetadataDocsWithIdentifier:(NSString *)identifier{
    identifierIn = identifier;
    testUrl = @"http://archive.org/metadata/%@";
    fileNameIn = nil;

    NSString *searchUrl = [NSString stringWithFormat:testUrl, identifier];
    [self setAndLoadDataFromJSONUrl:searchUrl];
}



- (void) getMetadataFileWithName:(NSString *)fileName withIdentifier:(NSString *)identifier{
    identifierIn = identifier;
    testUrl = @"http://archive.org/metadata/%@";
    fileNameIn = fileName;
 
    NSString *searchUrl = [NSString stringWithFormat:testUrl, identifier];
    [self setAndLoadDataFromJSONUrl:searchUrl];
}






- (void) loadMoreWithStart:(NSString *)start{
    [self getDocsWithTest:testUrl withStart:start];

}



#pragma mark - the shit

- (void) getDocsWithTest:(NSString *)test withStart:(NSString *)start{
    testUrl = test;
    NSString *searchUrl =[NSString stringWithFormat:@"%@&start=%@", testUrl, start];
    
    
    
    [self setAndLoadDataFromJSONUrl:searchUrl];
    
}



- (void) doRangeRequestFromRange:(unsigned int)fromByte toRange:(unsigned int)toByte fromUrl:(NSString *)url{

   // NSLog(@"-----> url: %@", url);
    
    //bookTextPageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    bookTextPageRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    // Define the bytes we wish to download.
    NSString *range = [NSString stringWithFormat:@"bytes=%i-%i", fromByte, toByte];
    //NSLog(@"-----> range: %@", range);
    
    [bookTextPageRequest setValue:range forHTTPHeaderField:@"Range"];

   
    NSURLConnection *myConnection = [[NSURLConnection alloc] initWithRequest:bookTextPageRequest delegate:self];
    if(myConnection){
        bookTextData = [NSMutableData data];
    
    }
    
    [myConnection start];
    
}


- (void) doBookPageRequest{
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:bookTextPageRequest delegate:self startImmediately:TRUE];
    if (!urlConnection) {
        
        
    }
    
    

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    //NSLog(@"  response statusCode: %i", [httpResponse statusCode]);
    [bookTextData setLength:0];


}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [bookTextData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
   // NSLog(@"Succeeded! Received %d bytes of data",[bookTextData length]);

    
    NSString *myString = [[NSString alloc] initWithData:bookTextData encoding:NSUTF8StringEncoding];
    
    if(delegate && [delegate respondsToSelector:@selector(dataDidFinishLoadingWithRangeRequestResults:)]){
        [delegate dataDidFinishLoadingWithRangeRequestResults:myString];
    }
    
    
}








@end
