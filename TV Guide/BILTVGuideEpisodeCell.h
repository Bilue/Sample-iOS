//
//  MI9EpisodeTVGuideCell.h
//  Zeus_iPad
//
//  Created by Cameron Barrie on 3/06/12.
//  Copyright (c) 2012 MI9. All rights reserved.
//

#import "BILTVGuideCell.h"

@interface BILTVGuideEpisodeCell : BILTVGuideCell {
    UILabel* _currentTitle;
    UILabel* _currentSubtitle;
    UILabel* _nextTitle;
    UILabel* _nextSubtitle;
}

@property (readonly) NSUInteger currentEpisodeIndex;
@property (readwrite, strong) NSMutableArray* episodes;
@property (readwrite, strong) NSDateFormatter* dateFormatter;

+ (UIFont *)headingFont;
+ (UIFont *)subHeadingFont;

- (void)clearEpisodes;
- (void)addEpisode:(id)episode;

- (void)displayEpisodeAtIndex:(NSInteger)index;

@end
