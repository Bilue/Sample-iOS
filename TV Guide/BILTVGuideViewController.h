//
//  BILViewController.h
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BILTVGuideGridView.h"

@class BILTVGuideEpisodesRequestModel;

@interface BILTVGuideViewController : UIViewController <BILTVGuideGridViewDataSource> {
    NSDateFormatter* _dateFormatter;
    
    BILTVGuideEpisodesRequestModel* _episodesRequestModel;
}

@property (nonatomic, strong) BILTVGuideEpisodesRequestModel* episodesRequestModel;
@property (nonatomic, readonly) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) IBOutlet BILTVGuideGridView* gridView;

@end
