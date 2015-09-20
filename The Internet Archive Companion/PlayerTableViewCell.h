//
//  PlayerTableViewCell.h
//  IA
//
//  Created by Hunter Brown on 7/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerFile.h"
#import "MediaPlayerViewController.h"

@interface PlayerTableViewCell : UITableViewCell

@property (nonatomic, strong) PlayerFile *file;
@property (nonatomic, weak) IBOutlet UILabel *fileTitle;
@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *formatLabel;
@property (nonatomic, weak) NSString *identifier;
@property (nonatomic, weak) MediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, weak) IBOutlet UIButton *viewButton;

- (void)setFormat:(NSString *)format;

- (IBAction)viewItem:(id)sender;

@end
