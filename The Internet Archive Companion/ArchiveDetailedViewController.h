//
//  ArchiveDetailedViewController.h
//  The Internet Archive Companion
//
//  Created by Hunter on 1/31/13.
//  Copyright (c) 2013 Hunter Lee Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveSearchDoc.h"
#import "ArchiveDataService.h"

@interface ArchiveDetailedViewController : UIViewController <ArchiveDataServiceDelegate> {
    
    ArchiveDataService *service;
  

}

@property (nonatomic, retain) IBOutlet UILabel *docTitle;
@property (nonatomic, retain) ArchiveDetailDoc *doc;
@property (nonatomic, retain) NSString *identifier;



@end
