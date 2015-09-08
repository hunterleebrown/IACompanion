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
#import "MediaUtils.h"

@interface IAJsonDataService ()
@property (nonatomic, strong) NSString *testUrl;
@property (nonatomic, strong) NSString *loadMoreStart;
@property (nonatomic, strong) NSString *fileNameIn;
@property (nonatomic, strong) NSString *identifier;


@end


@implementation IAJsonDataService

@synthesize rawResults, identifier, testUrl, loadMoreStart, fileNameIn;




- (id) initForAllItemsWithCollectionIdentifier:(NSString *)idString sortType:(IADataServiceSortType *)type {
    self = [super init];
    if(self){
//        NSLog(@"---------> sort type:%@", type);

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
        testUrl = [NSString stringWithFormat:@"http://archive.org/advancedsearch.php?q=%@&output=json&rows=50", realQuery];
        self.urlStr = testUrl;
    }
    
    return self;
}

- (id)initWithAllPicks
{
    self = [super init];
    if(self){
        NSString *pick = @"pick:1+AND+NOT+collection:opensource_movies+AND+NOT+collection:opensource_audio+AND+NOT+collection:zoterocommons+AND+NOT+collection:scholarworkspaces+AND+NOT+collection:test_collection+AND+NOT+collection:opensource+AND+NOT+collection:ourmedia+AND+NOT+collection:open_source_software+AND+NOT+collection:opensource_media+AND+NOT+collection:web+AND+NOT+collection:webwidecrawl";

//        NSString *pick = @"pick:1+AND+NOT+collection:open_source_audio+AND+NOT+collection:open_source_movies+";

        NSString *realQuery = [NSString stringWithFormat:@"%@", pick];
        testUrl = [NSString stringWithFormat:@"http://archive.org/advancedsearch.php?q=%@&output=json&rows=50", realQuery];
        self.urlStr = testUrl;
        [self searchChangeSortType:IADataServiceSortTypeDateDescending];
    }

    return self;
}


- (NSString *)sortStringFromType:(IADataServiceSortType)type{

    switch (type) {
        case IADataServiceSortTypeDateDescending:
            return  @"publicdate+desc";
            break;
        case IADataServiceSortTypeDateAscending:
            return @"publicdate+asc";
            break;

        case IADataServiceSortTypeDownloadDescending:
            return @"downloads+desc";
            break;
        case IADataServiceSortTypeDownloadAscending:
            return  @"downloads+asc";
            break;

        case IADataServiceSortTypeTitleDescending:
            return @"titleSorter+desc";
            break;

        case IADataServiceSortTypeTitleAscending:
            return @"titleSorter+asc";
            break;

        case IADataServiceSortTypeNone:
            return @"";
            break;
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
    
    NSLog(@"---------> identifier:%@", identifier);
    
    self.urlStr = [NSString stringWithFormat:testUrl, identifier];
}

- (void) changeToSubCollections {
    testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@+AND+mediatype:collection&sort[]=downloads+desc&rows=50&output=json";
    loadMoreStart = @"0";
    self.urlStr = [NSString stringWithFormat:testUrl, self.identifier];
    
    
}

- (void) searchChangeSortType:(IADataServiceSortType *)type
{

    if(identifier){
        testUrl = [NSString stringWithFormat:testUrl, identifier];
    }
    
    NSString *sort = @"";
    if(![[self sortStringFromType:type] isEqualToString:@""])
    {
        sort = [NSString stringWithFormat:@"&sort[]=%@", [self sortStringFromType:type]];
    }
    
    self.urlStr = [NSString stringWithFormat:@"%@%@", testUrl, sort];

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
    
    if(![sort isEqualToString:@""]){
        sort = [NSString stringWithFormat:@"&sort[]=%@", sort];
    }
    
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
        } else if(type == MediaTypeSoftware){
            t = @"software";
        } else if(type == MediaTypeEtree){
            t = @"etree";
        }

        
        
        testUrl = @"http://archive.org/advancedsearch.php?q=mediatype:%@+AND+NOT+hidden:true+AND+collection:%@%@&rows=50&output=json";
        

        NSString *searchUrl = [NSString stringWithFormat:testUrl, t, identifier, sort];
        return [self docsUrlStringWithTest:searchUrl withStart:loadMoreStart];
        
    } else {
        testUrl = @"http://archive.org/advancedsearch.php?q=collection:%@%@&rows=50&output=json";
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
            
                    [aDoc setType:[MediaUtils mediaTypeFromString:[doc objectForKey:@"mediatype"]]];
                    
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
        
        if([[metadata objectForKey:@"title"] isKindOfClass:[NSArray class]])
        {
            [dDoc setTitle:[metadata objectForKey:@"title"][0]];
        }
        else
        {
            [dDoc setTitle:[metadata objectForKey:@"title"]];
        }
        
        if(![metadata objectForKey:@"headerImage"]){
            [dDoc setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/img/%@", dDoc.identifier]];
            ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:dDoc.headerImageUrl];
            [dDoc setArchiveImage:anImage];
        } else {
            [dDoc setHeaderImageUrl:[metadata objectForKey:@"headerImage"]];
            ArchiveImage *anImage = [[ArchiveImage alloc] initWithUrlPath:dDoc.headerImageUrl];
            [dDoc setArchiveImage:anImage];
        }
        
        // Descriptions can now be arrays... yay
        if([[metadata objectForKey:@"description"] isKindOfClass:[NSArray class]])
        {
            NSArray *desc = [metadata objectForKey:@"description"];
            NSMutableString *descText = [NSMutableString new];
            
            for(NSObject *obj in desc)
            {
                if([obj isKindOfClass:[NSString class]])
                {
                    [descText appendString:[NSString stringWithFormat:@"%@\n", obj]];
                }
            }
            [dDoc setDetails:descText];

        } else
        {
            [dDoc setDetails:[metadata objectForKey:@"description"]];
        }
        
        
        [dDoc setPublicDate:[metadata objectForKey:@"publicdate"]];
        if([metadata objectForKey:@"date"] != nil)
        {
            [dDoc setDate:[metadata objectForKey:@"date"]];
        }
        
        NSMutableArray *files = [NSMutableArray new];
        if([jsonResponse objectForKey:@"files"]){
            for (NSDictionary *file in [jsonResponse objectForKey:@"files"]) {
                ArchiveFile *aFile = [[ArchiveFile alloc]initWithIdentifier:dDoc.identifier withIdentifierTitle:dDoc.title withServer:[jsonResponse objectForKey:@"server"] withDirectory:[jsonResponse objectForKey:@"dir"] withFile:file];
                [files addObject:aFile];
            }
        }
        [dDoc setFiles:files];

        [dDoc setType:[MediaUtils mediaTypeFromString:[metadata objectForKey:@"mediatype"]]];

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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:@"Download failed. Is your internet connection working?"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;


}

- (void) didFinishFileDownload:(ArchiveFileDownload *)download{
    [super didFinishFileDownload:download];

    NSError *error = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:download.data options:NSJSONReadingMutableContainers error:&error];
    
    @try {
        [self packageJsonResponeDictionary:jsonResponse];
    } @catch (NSException *exception) {
        
        NSString *reason = exception.reason;
        NSString *name = exception.name;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:@"Something went wrong with parsing data from the Internet Archive Server. Try again."];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLoadingIndicator" object:[NSNumber numberWithBool:NO]];


    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
}

@end
