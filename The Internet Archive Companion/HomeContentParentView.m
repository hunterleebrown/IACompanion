//
//  HomeContentParentView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/10/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeContentParentView.h"

@implementation HomeContentParentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) didTouchNavigationCellWithDoc:(ArchiveSearchDoc *)doc{


    
    
    
    
    
    NSString *html = [NSString stringWithFormat:@"<html><head><style>a:link{color:#666; text-decoration:none;}</style></head><body style='background-color:#fff; color:#000; font-size:14px; font-family:\"Courier New\"'>%@</body></html>", doc.description];
    
    
    NSURL *theBaseURL = [NSURL URLWithString:@"http://archive.org"];
    [_homeContentDescriptionView loadData:[html dataUsingEncoding:NSUTF8StringEncoding]
                  MIMEType:@"text/html"
          textEncodingName:@"UTF-8"
                   baseURL:theBaseURL];
    
    
    [_homeContentTableView.service getDocsWithCollectionIdentifier:doc.identifier];
    
}


@end
