//
//  MeidaPlayerViewController.h
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaPlayerViewController : UIViewController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)closePlayer;


@end
