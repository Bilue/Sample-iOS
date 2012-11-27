//
//  BILViewController.h
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BILTVGuideGridView.h"

@interface BILTVGuideViewController : UIViewController <BILTVGuideGridViewDataSource> {
    NSDateFormatter* _dateFormatter;
}

@property (nonatomic, readonly) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) BILTVGuideGridView* gridView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
