//
//  HomeNavTableView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeNavTableView.h"
#import "HomeNavCell.h"

@implementation HomeNavTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setDataSource:self];
        [self setDelegate:self];
 
    }
    return self;
}



- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Top Collections";
    }
    else return @"";
}


- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeNavCell"];
      
    switch (indexPath.row) {
        case 0:
            [cell.navImageView setImage:[UIImage imageNamed:@"audio.gif"]];
            [cell.title setText:@"Audio"];
            break;
        case 1:
            [cell.navImageView setImage:[UIImage imageNamed:@"movies.gif"]];
            [cell.title setText:@"Movies"];
            break;
        case 2:
            [cell.navImageView setImage:[UIImage imageNamed:@"texts.gif"]];
            [cell.title setText:@"Texts"];
            break;
        default:
            break;
    }
    
    
    
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
