//
//  IAJsonService.m
//  IA
//
//  Created by Hunter on 6/29/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "IAJsonDataService.h"
#import "ArchiveSearchDoc.h"
#import "StringUtils.h"

@interface IAJsonDataService ()
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *testUrl;
@property (nonatomic, strong) NSString *loadMoreStart;

@end


@implementation IAJsonDataService

@synthesize rawResults, identifier, testUrl, loadMoreStart;


- (id) initForAllItemsWithCollectionIdentifier:(NSString *)idString{
    self = [self init];
    if(self){
        identifier = idString;
        loadMoreStart = @"0";
        self.urlStr = [self docsUrlStringsWithType:MediaTypeCollection withIdentifier:identifier withSort:@"titleSorter+asc"];

    }
    
    return self;
}



- (NSString *) docsUrlStringsWithType:(MediaType)type withIdentifier:(NSString *)idString withSort:(NSString *)sort{
    
    identifier = idString;
    
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
        return [self docsUrlStringWithTest:searchUrl withStart:loadMoreStart];
        
    } else {
        testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@&sort[]=%@&sort[]=&sort[]=&rows=50&page=1&output=json";
        NSString *searchUrl = [NSString stringWithFormat:testUrl, identifier, sort];
        return [self docsUrlStringWithTest:searchUrl withStart:loadMoreStart];
    }
    

    
}


- (NSString *) docsUrlStringWithTest:(NSString *)test withStart:(NSString *)start{
    testUrl = test;
    return [NSString stringWithFormat:@"%@&start=%@", testUrl, start];
}



- (void) packageJsonResponeDictionary:(NSDictionary *)jsonResponse{

        
        rawResults = [NSMutableDictionary new];
        [rawResults setObject:jsonResponse forKey:@"original"];
        NSMutableArray *responseDocs = [NSMutableArray new];
        
        NSDictionary *response = [jsonResponse objectForKey:@"response"];
        NSDictionary *metadata = [jsonResponse objectForKey:@"metadata"];
        
        
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
                            ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:aDoc.headerImageUrl];
                            [anImage startDownloading];
                            [aDoc setArchiveImage:anImage];
                            
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
            [dDoc setRawDoc:jsonResponse];
            NSDictionary *metadata = [jsonResponse objectForKey:@"metadata"];
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
            if([jsonResponse objectForKey:@"files"]){
                for (NSDictionary *file in [jsonResponse objectForKey:@"files"]) {
                    ArchiveFile *aFile = [[ArchiveFile alloc]initWithIdentifier:dDoc.identifier withIdentifierTitle:[StringUtils stringFromObject:dDoc.title] withServer:[jsonResponse objectForKey:@"server"] withDirectory:[jsonResponse objectForKey:@"dir"] withFile:file];
                    [files addObject:aFile];
                }
            }
            [dDoc setFiles:files];
            
            
            
            [responseDocs addObject:dDoc];
            [rawResults setObject:responseDocs forKey:@"documents"];
            
        }
        
   //     if(identifierIn){
    //        [rawResults setObject:identifierIn forKey:@"identifier"];
    //    }
        
        /*
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
        
        
        
        */
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataDidBecomeAvailableForService:)]){
        [self.delegate dataDidBecomeAvailableForService:self];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;



}




- (void) didFinishFileDownload:(ArchiveFileDownload *)download{
    [super didFinishFileDownload:download];
    
    NSError *error = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:download.data options:NSJSONReadingMutableContainers error:&error];

    assert(jsonResponse != nil);
    [self packageJsonResponeDictionary:jsonResponse];
    
    
}

@end
