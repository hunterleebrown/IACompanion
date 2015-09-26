//
//  MeidaPlayerViewController.h
//  IA
//
//  Created by Hunter Brown on 7/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MediaPlayerViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UIToolbar *playerToolbar;
@property (nonatomic, weak) IBOutlet UITapGestureRecognizer *topTapGestureRecognizer;


- (IBAction)closePlayer;


@end
