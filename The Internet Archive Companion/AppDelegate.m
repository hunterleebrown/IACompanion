//
//  AppDelegate.m
//  The Internet Archive Companion
//
//  Created by Hunter on 1/15/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreData/CoreData.h>
#import "PopUpView.h"
#import "InitialViewController.h"
#import "FontMapping.h"

@interface AppDelegate ()

@property (nonatomic, strong) PopUpView *popUpView;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize popUpView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.


    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    popUpView = [[PopUpView alloc] initWithFrame:CGRectZero];
    [self.window addSubview:popUpView];

    [self.window makeKeyAndVisible];


//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }

    [self accessibilityLabels];

    return YES;
}



- (void)accessibilityLabels
{

    [ARCHIVE setAccessibilityLabel:@"Archive"];
    
    [AUDIO setAccessibilityLabel:@"Audio"];
    [AUDIO setAccessibilityHint:@"Audio Type"];
    
    [VIDEO setAccessibilityLabel:@"Video"];
    [VIDEO setAccessibilityHint:@"Video Type"];
    
    [BOOK setAccessibilityLabel:@"Text"];
    [BOOK setAccessibilityHint:@"Text Type"];
    
    [IMAGE setAccessibilityLabel:@"Image"];
    [IMAGE setAccessibilityHint:@"Image Type"];
    

    [FAVORITE setAccessibilityLabel:@"Favorites"];
    [MEDIAPLAYER setAccessibilityLabel:@"Media player"];
    [HAMBURGER setAccessibilityLabel:@"Main Navigation"];
    [SEARCH setAccessibilityLabel:@"Search"];
    
    [COLLECTION setAccessibilityLabel:@"Collection"];
    [FOLDER setAccessibilityLabel:@"Files"];
    
    [CLOSE setAccessibilityLabel:@"Close"];
    [FULLSCREEN setAccessibilityLabel:@"Full Screen"];
    
}


- (void) showPopUpWithMessageNotification:(NSNotification *)notification{

    if(!popUpView.expanded) {
        [self.window bringSubviewToFront:popUpView];
        [popUpView showWithSubView:nil title:@"Something went wrong..." message:notification.object];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // reactivate audio session
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
