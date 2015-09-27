//
//  PlayerTableViewCell.m
//  IA
//
//  Created by Hunter Brown on 7/16/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "PlayerTableViewCell.h"
#import "ArchiveFile.h"
#import "MediaUtils.h"
#import "ItemContentViewController.h"

@interface PlayerTableViewCell ()

@property (nonatomic) FileFormat fileFormat;

@end

@implementation PlayerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

    if(selected){
        [self.fileTitle setTextColor:[UIColor redColor]];
        [self.fileTitle setFont:[UIFont boldSystemFontOfSize:self.fileTitle.font.pointSize]];
    } else {
        [self.fileTitle setTextColor:[UIColor whiteColor]];
        [self.fileTitle setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];

    }

}

- (void) setFormat:(NSString *)format
{
    self.fileFormat = format;
    self.formatLabel.text = [MediaUtils iconStringFromFormat:[MediaUtils formatFromString:format]];
    [self.formatLabel setTextColor:[MediaUtils colorForFileFormat:[MediaUtils formatFromString:format]]];
}


- (IBAction)viewItem:(id)sender
{

    NSLog(@"----------> identifier:%@", self.identifier);
    
    ArchiveSearchDoc *doc = [ArchiveSearchDoc new];
    doc.identifier = self.identifier;
    doc.type = [MediaUtils mediaTypeFromFileFormat:self.fileFormat];
    doc.title = self.file.title;

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ItemContentViewController *cvc = [self.mediaPlayerViewController.storyboard instantiateViewControllerWithIdentifier:@"itemViewController"];
        [cvc setSearchDoc:doc];
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:cvc];
        [pop presentPopoverFromRect:self.mediaPlayerViewController.playerToolbar.frame inView:self.mediaPlayerViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CellSelectNotification" object:doc];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMediaPlayer" object:nil];

    }
    
}


- (void)awakeFromNib {
    
    // -------------------------------------------------------------------
    // We need to create our own constraint which is effective against the
    // contentView, so the UI elements indent when the cell is put into
    // editing mode
    // -------------------------------------------------------------------
    
    // Remove the IB added horizontal constraint, as that's effective
    // against the cell not the contentView
   // [self removeConstraint:self.cellLabelHSpaceConstraint];
    
    // Create a dictionary to represent the view being positioned
    NSDictionary *labelViewDictionary = NSDictionaryOfVariableBindings(_fileTitle);
    
    // Create the new constraint
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_fileTitle]" options:0 metrics:nil views:labelViewDictionary];
    
    // Add the constraint against the contentView
    [self.contentView addConstraints:constraints];
    
}

@end
