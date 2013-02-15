//
//  ArchivePlayerViewController.m
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "ArchivePlayerViewController.h"
#import "ArchivePlayerTableViewCell.h"

@interface ArchivePlayerViewController () {
    NSMutableArray *playerFiles;

}

@end

@implementation ArchivePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        playerFiles = [NSMutableArray new];
    
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    
    ArchiveFile *one = [ArchiveFile new];
    one.identifier = @"Worked Brass";
    one.title = @"Fanfare";
    
    ArchiveFile *two = [ArchiveFile new];
    two.identifier = @"Worked Brass";
    two.title = @"Dasha Lilt";

    
    ArchiveFile *three = [ArchiveFile new];
    three.identifier = @"Worked Brass";
    three.title = @"Katya's Journey";
    
    ArchiveFile *four = [ArchiveFile new];
    four.identifier = @"Worked Brass";
    four.title = @"Energetico";

    [playerFiles addObject:one];
    [playerFiles addObject:two];
    [playerFiles addObject:three];
    [playerFiles addObject:four];
    
    
    [_playerTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return playerFiles.count;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchivePlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
    
    ArchiveFile *file = [playerFiles objectAtIndex:indexPath.row];
    
    cell.fileTitle.text = file.title;
    cell.identifierLabel.text = file.identifier;
    return cell;
    
}






@end
