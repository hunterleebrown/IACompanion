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
@property (nonatomic, strong) NSString *fileNameIn;


@end


@implementation IAJsonDataService

@synthesize rawResults, identifier, testUrl, loadMoreStart, fileNameIn;




- (id) initForAllItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type {
    self = [super init];
    if(self){
        identifier = idString;
        loadMoreStart = @"0";
        self.urlStr = [self docsUrlStringsWithType:MediaTypeNone withIdentifier:identifier withSort:[self sortStringFromType:type]];
    }
    
    return self;
}

- (id) initForAllCollectionItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type {
    self = [super init];
    if(self){
        identifier = idString;
        loadMoreStart = @"0";
        self.urlStr = [self docsUrlStringsWithType:MediaTypeCollection withIdentifier:identifier withSort:[self sortStringFromType:type]];
    }
    
    return self;
}

- (id) initWithQueryString:(NSString *)query {
    self = [super init];
    if(self){
        NSString *realQuery = [NSString stringWithFormat:@"%@+AND+NOT+collection:web+AND+NOT+collection:webwidecrawl", query];
       // NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL,	 (CFStringRef)realQuery,	 NULL,	 (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingISOLatin1));
        
        testUrl = [NSString stringWithFormat:@"http://archive.org/advancedsearch.php?q=%@&output=json&rows=50", realQuery];
        self.urlStr = testUrl;
    }
    
    return self;
}





- (NSString *)sortStringFromType:(IADataServiceSortType)type{
    if(type == IADataServiceSortTypeDownloadCount) {
        return @"downloads+desc";
    } else if(type == IADataServiceSortTypeDateDescending){
        return  @"publicdate+desc";
    } else {
        return @"titleSorter+asc";
    }
}

- (id) initForMetadataDocsWithIdentifier:(NSString *)ident{
    self = [self init];
    if(self){
        testUrl = @"http://archive.org/metadata/%@";
        identifier = ident;
        self.urlStr = [NSString stringWithFormat:testUrl, identifier];
    }
    return self;
}

- (void) changeToStaffPicks {
    testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@+pick:1&rows=50&output=json";
    loadMoreStart = @"0";
    self.urlStr = [NSString stringWithFormat:testUrl, identifier];
}

- (void) changeToSubCollections {
    testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@+AND+mediatype:collection&sort[]=downloads+desc&rows=50&output=json";
    loadMoreStart = @"0";
    self.urlStr = [NSString stringWithFormat:testUrl, self.identifier];
    
    
}


- (void) changeSortType:(IADataServiceSortType *)type {
    loadMoreStart = @"0";
    self.urlStr = [self docsUrlStringsWithType:MediaTypeCollection withIdentifier:identifier withSort:[self sortStringFromType:type]];

}

- (void) setLoadMoreStart:(NSString *)lMS{
    loadMoreStart = lMS;
    NSString *pre =[NSString stringWithFormat:testUrl, self.identifier];
    self.urlStr = [self docsUrlStringWithTest:pre withStart:loadMoreStart];
    
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
        } else if(type == MediaTypeImage){
            t = @"image";
        }
        
        
        testUrl = @"http://archive.org/advancedsearch.php?q=mediatype:%@+AND+NOT+hidden:true+AND+collection:%@&sort[]=%@&sort[]=&sort[]=&rows=50&output=json";
        NSString *searchUrl = [NSString stringWithFormat:testUrl, t, identifier, sort];
        return [self docsUrlStringWithTest:searchUrl withStart:loadMoreStart];
        
    } else {
        testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@&sort[]=%@&sort[]=&sort[]=&rows=50&output=json";
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
                        [aDoc setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/img/%@", aDoc.identifier]];
                        ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:aDoc.headerImageUrl];
                        [aDoc setArchiveImage:anImage];
                        
                    } else {
                        [aDoc setHeaderImageUrl:[doc objectForKey:@"headerImage"]];
                        ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:aDoc.headerImageUrl];
                        [aDoc setArchiveImage:anImage];
                    }
                    [aDoc setDetails:[doc objectForKey:@"description"]];
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
                    } else if([[doc objectForKey:@"mediatype"] isEqualToString:@"image"]){
                        [aDoc setType:MediaTypeImage];

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
            [dDoc setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/img/%@", dDoc.identifier]];
            ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:dDoc.headerImageUrl];
            [dDoc setArchiveImage:anImage];
        } else {
            [dDoc setHeaderImageUrl:[metadata objectForKey:@"headerImage"]];
            ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:dDoc.headerImageUrl];
            [dDoc setArchiveImage:anImage];
        }
        [dDoc setDetails:[metadata objectForKey:@"description"]];
        [dDoc setPublicDate:[metadata objectForKey:@"publicdate"]];
        
        NSMutableArray *files = [NSMutableArray new];
        if([jsonResponse objectForKey:@"files"]){
            for (NSDictionary *file in [jsonResponse objectForKey:@"files"]) {
                ArchiveFile *aFile = [[ArchiveFile alloc]initWithIdentifier:dDoc.identifier withIdentifierTitle:[StringUtils stringFromObject:dDoc.title] withServer:[jsonResponse objectForKey:@"server"] withDirectory:[jsonResponse objectForKey:@"dir"] withFile:file];
                [files addObject:aFile];
            }
        }
        [dDoc setFiles:files];
        
        if([[metadata objectForKey:@"mediatype"] isEqualToString:@"collection"]){
            [dDoc setType:MediaTypeCollection];
        } else if([[metadata objectForKey:@"mediatype"] isEqualToString:@"audio"]){
            [dDoc setType:MediaTypeAudio];
        } else if([[metadata objectForKey:@"mediatype"] isEqualToString:@"video"]){
            [dDoc setType:MediaTypeVideo];
        } else if([[metadata objectForKey:@"mediatype"] isEqualToString:@"texts"]){
            [dDoc setType:MediaTypeTexts];
        } else {
            [dDoc setType:MediaTypeAny];
        }
        
        [responseDocs addObject:dDoc];
        [rawResults setObject:responseDocs forKey:@"documents"];
        
    }
    
    if(identifier){
        [rawResults setObject:identifier forKey:@"identifier"];
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
            
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(dataDidFinishLoadingWithArchiveFile:)]){
                [self.delegate dataDidFinishLoadingWithArchiveFile:aFile];
            }
        }
        
        
        
    } else {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(dataDidBecomeAvailableForService:)]){
            [self.delegate dataDidBecomeAvailableForService:self];
        }
    }
    
    
    
    
    
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    
}


- (void) didFailFileDownload:(ArchiveFileDownload *)download{

   // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download Failure" message:@"Couldn't complete request." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
    //[alert show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:@"Download failed. Is your internet connection working?"];
    
    
}

- (void) didFinishFileDownload:(ArchiveFileDownload *)download{
    [super didFinishFileDownload:download];

    NSError *error = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:download.data options:NSJSONReadingMutableContainers error:&error];
    
    @try {
        [self packageJsonResponeDictionary:jsonResponse];
    } @catch (id exception) {
        //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Issue" message:[NSString stringWithFormat:@"%@", @"Something went wrong in interpreting data from the server. Try again."] delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
        //  [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:@"Something went wrong with parsing data from the Internet Archive Server. Try again."];
        
    
    }

    
}

@end
