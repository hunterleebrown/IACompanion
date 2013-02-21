//
//  HomeNavTableView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeNavTableView.h"
#import "HomeNavCell.h"
#import "HomeNavSectionView.h"
#import "ArchiveSearchDoc.h"

@interface HomeNavTableView () {

    
    
    NSMutableArray *audioDocs;
    NSMutableArray *videoDocs;
    NSMutableArray *textDocs;
    

}

@end

@implementation HomeNavTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setDataSource:self];
        [self setDelegate:self];
        _audioService = [ArchiveDataService new];
        [_audioService setDelegate:self];

        _movieService = [ArchiveDataService new];
        [_movieService setDelegate:self];
        
        _textService = [ArchiveDataService new];
        [_textService setDelegate:self];
        
        audioDocs = [NSMutableArray new];
        videoDocs = [NSMutableArray new];
        textDocs = [NSMutableArray new];
        

        
        
        

        
        
 
    }
    return self;
}


- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    
    
    
    if([[results objectForKey:@"identifier"] isEqualToString:@"audio"]){
        [audioDocs addObjectsFromArray:[results objectForKey:@"documents"]];

    } else if([[results objectForKey:@"identifier"] isEqualToString:@"movies"]) {
        [videoDocs addObjectsFromArray:[results objectForKey:@"documents"]];

    } else if([[results objectForKey:@"identifier"] isEqualToString:@"texts"]){
        [textDocs addObjectsFromArray:[results objectForKey:@"documents"]];

    }
    
    [self reloadData];
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomeNavSectionView *sectionView = [[HomeNavSectionView alloc] initWithFrame:CGRectMake(0, 0, 256, 76)];
    
    switch (section) {
        case 0:
            [sectionView.title setText:@"Audio"];
            [sectionView.imageView setImage:[UIImage imageNamed:@"audio.gif"]];
            break;
        case 1:
            [sectionView.title setText:@"Video"];
            [sectionView.imageView setImage:[UIImage imageNamed:@"movies.gif"]];
            break;
        case 2:
            [sectionView.title setText:@"Text"];
            [sectionView.imageView setImage:[UIImage imageNamed:@"texts.gif"]];
            break;
        default:
            break;
    }
    
    return sectionView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 76.0;
}





- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return audioDocs.count;
            break;
        case 1:
            return videoDocs.count;
            break;
        case 2:
            return textDocs.count;
            break;
        default:
            return 0;
            break;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeNavCell"];
    ArchiveSearchDoc *doc;
    [cell.navImageView setImage:nil];
    [cell.title setText:nil];

    
    switch (indexPath.section) {
        case 0:
            doc = [audioDocs objectAtIndex:indexPath.row];
            break;
        case 1:
            doc = [videoDocs objectAtIndex:indexPath.row];
            break;
        case 2:
            doc = [textDocs objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    [cell.title setText:doc.title];
    [cell.navImageView setAndLoadImageFromUrl:doc.headerImageUrl];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchiveSearchDoc *doc;
    switch (indexPath.section) {
        case 0:
            doc = [audioDocs objectAtIndex:indexPath.row];
            break;
        case 1:
            doc = [videoDocs objectAtIndex:indexPath.row];
            break;
        case 2:
            doc = [textDocs objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    if(_touchDelegate && [_touchDelegate respondsToSelector:@selector(didTouchNavigationCellWithDoc:)]){
        [_touchDelegate didTouchNavigationCellWithDoc:doc];
    }

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
