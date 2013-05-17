//
//  ArchivePlayerViewController.h
//  IA
//
//  Created by Hunter Brown on 2/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveFile.h"
#import "AsyncImageView.h"
#import "ArchiveDataService.h"
#import <CoreData/CoreData.h>


@interface ArchivePlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ArchiveDataServiceDelegate, NSFetchedResultsControllerDelegate> {

    

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@property (nonatomic, retain) IBOutlet UITableView *playerTableView;
@property (nonatomic, weak) IBOutlet UIView *playerHolder;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editListButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *hidePlayerButton;
@property (nonatomic, weak) IBOutlet UIButton *upupButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearButton;


@property (nonatomic, weak) IBOutlet UIBarButtonItem *playPause;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *next;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *previous;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwards;
@property (nonatomic, weak) IBOutlet UIButton *forwardsButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backwards;
@property (nonatomic, weak) IBOutlet UIButton *backwardsButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *numberOfFiles;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;
@property (nonatomic, weak) IBOutlet UIButton *togglePlayerButton;

@property (nonatomic, weak) IBOutlet UILabel *instructions;

@property (nonatomic, weak) IBOutlet AsyncImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;

@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, assign) NSTimeInterval totalVideoTime;
@property (nonatomic, weak) IBOutlet UILabel *sliderMinLabel;
@property (nonatomic, weak) IBOutlet UILabel *sliderMaxLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;

- (IBAction)didTouchUp:(id)sender;
- (IBAction)didTouchDown:(id)sender;
- (IBAction)sliderDidChangeValue:(id)sender;


- (IBAction)doPlayPause:(id)sender;
- (IBAction)doNext:(id)sender;
- (IBAction)doPrevious:(id)sender;
- (IBAction)doForwards:(id)sender;
- (IBAction)doBackwards:(id)sender;
- (IBAction)togglePlayer:(id)sender;




- (IBAction)editList:(id)sender;
- (IBAction)clearList:(id)sender;
- (IBAction)hidePlayer:(id)sender;

@end
