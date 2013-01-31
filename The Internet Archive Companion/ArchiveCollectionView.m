//
//  ArchiveCollectionView.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/27/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveCollectionView.h"
#import "ArchiveCollectionCell.h"
#import "ArchiveSearchDoc.h"
#import <QuartzCore/QuartzCore.h>


@implementation ArchiveCollectionView


- (void) getCollectionWithName:(NSString *)name{
    dataService = [ArchiveDataService new];
    [dataService setDelegate:self];
    [dataService getCollectionsWithName:name];
    [self setDelegate:self];
    [self setDataSource:self];
    
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowColor = [UIColor blackColor].CGColor;

    

}


- (void) dataDidFinishLoadingWithDictionary:(NSDictionary *)results{
    docs = [results objectForKey:@"documents"];
    [self reloadData];
 
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return docs.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    /*
    NSString *cellId;
    if(cv.restorationIdentifier isEqualToString:@"audioCollection"){
        cellID = @"audioCell";
    }
    
    //
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
    cell.image.image = [UIImage imageNamed:imageToLoad];
    */
    
    NSString *rName = cv.restorationIdentifier;
    NSString *cellId;
    
    if([rName isEqualToString:@"audioCollection"]){
        cellId = @"audioCell";
    }
    if([rName isEqualToString:@"videoCollection"]){
        cellId = @"videoCell";
    }
    if([rName isEqualToString:@"textCollection"]){
        cellId = @"textCell";
    }
    
    
    ArchiveSearchDoc *doc = [docs objectAtIndex:indexPath.row];
    NSString *tit = doc.title;
    
    ArchiveCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell.title setText:tit];
    [cell.imageView setAndLoadImageFromUrl:doc.headerImageUrl];
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
