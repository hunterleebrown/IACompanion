//
//  MetaDataTablePopUpView.m
//  IA
//
//  Created by Hunter Brown on 7/14/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "MetaDataTablePopUpView.h"
#import "MetaCell.h"
#import "StringUtils.h"

@interface MetaDataTablePopUpView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *metaTable;
@property (nonatomic, strong) NSMutableDictionary *metaData;
@end

@implementation MetaDataTablePopUpView
@synthesize metaTable, metaData;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        metaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [metaTable setDelegate:self];
        [metaTable setDataSource:self];
        metaData = [NSMutableDictionary new];
        
    }
    return self;
}


- (void) showPopUpWithMetaData:(NSDictionary *)metadata{

    NSArray *metakeys;
    metakeys = [metadata allKeys];
    for(NSString *k in metakeys){
        [metaData setObject:[metadata objectForKey:k] forKey:k];
    }
    [metaData removeObjectForKey:@"identifier"];
    [metaData removeObjectForKey:@"title"];
    [metaData removeObjectForKey:@"description"];
    [metaData removeObjectForKey:@"subject"];
    [metaData removeObjectForKey:@"md5s"];
    
    
    [metaTable reloadData];

    [super showWithSubView:metaTable title:@"MetaData" message:nil];
    
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return metaData.count;
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *valueText = [StringUtils stringFromObject:[metaData objectForKey:[metaData.allKeys objectAtIndex:indexPath.row]]];
    return [MetaCell heightForValue:valueText] > 44 ? [MetaCell heightForValue:valueText] : 44;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MetaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"metaCell"];
    if(!cell){
        cell = [[MetaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"metaCell"];
    }
    
    
    
    NSString *titleText = [[metaData.allKeys objectAtIndex:indexPath.row] capitalizedString];
    NSString *valueText = [StringUtils stringFromObject:[metaData objectForKey:[metaData.allKeys objectAtIndex:indexPath.row]]];

    [cell setTitle:titleText setValue:valueText];
    
    return cell;
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
