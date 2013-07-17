//
//  SearchView.m
//  IA
//
//  Created by Hunter Brown on 7/17/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "SearchView.h"
#import "IAJsonDataService.h"

@interface SearchView () <IADataServiceDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IAJsonDataService *service;


@end

@implementation SearchView
@synthesize service;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    
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

@end
