//
//  HomeNavTableView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 2/9/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "HomeNavTableView.h"
#import "HomeNavCell.h"
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
        

        
        [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor blackColor]];

        

        
        
 
    }
    return self;
}


- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    
    
    
    if([[results objectForKey:@"identifier"] isEqualToString:@"audio"]){
        ArchiveSearchDoc *topAudio = [ArchiveSearchDoc new];
        [topAudio setIdentifier:@"audio"];
        [topAudio setTitle:@"ALL AUDIO"];
        [topAudio setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", @"audio"]];
        [audioDocs addObject:topAudio];
        [audioDocs addObjectsFromArray:[results objectForKey:@"documents"]];

    } else if([[results objectForKey:@"identifier"] isEqualToString:@"movies"]) {
        ArchiveSearchDoc *topVideo = [ArchiveSearchDoc new];
        [topVideo setIdentifier:@"movies"];
        [topVideo setTitle:@"ALL VIDEO"];
        [topVideo setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", @"movies"]];
        [videoDocs addObject:topVideo];
        [videoDocs addObjectsFromArray:[results objectForKey:@"documents"]];
        [videoDocs addObjectsFromArray:[results objectForKey:@"documents"]];

    } else if([[results objectForKey:@"identifier"] isEqualToString:@"texts"]){
        ArchiveSearchDoc *topTexts = [ArchiveSearchDoc new];
        [topTexts setIdentifier:@"texts"];
        [topTexts setTitle:@"ALL TEXTS"];
        [topTexts setHeaderImageUrl:[NSString stringWithFormat:@"http://archive.org/services/get-item-image.php?identifier=%@", @"texts"]];
        [textDocs addObject:topTexts];
        [textDocs addObjectsFromArray:[results objectForKey:@"documents"]];
        
        [textDocs addObjectsFromArray:[results objectForKey:@"documents"]];

    }
    
    [self reloadData];
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Audio Collections";
            break;
        case 1:
            return @"Video Collections";
            break;
        case 2:
            return @"Text Collections";
            break;
        default:
            return 0;
            break;
    }


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
    if (indexPath.row == 0) {
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
        [cell.title setTextColor:[UIColor whiteColor]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell.title setTextColor:[UIColor blackColor]];

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



    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavCellSelectNotification" object:doc];

    
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
