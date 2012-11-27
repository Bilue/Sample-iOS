//
//  MI9TVGuideCell.m
//  Zeus_iPad
//
//  Created by Cameron Barrie on 3/06/12.
//  Copyright (c) 2012 MI9. All rights reserved.
//

#import "BILTVGuideCell.h"
#import "BILTVGuideEpisodeCell.h"
#import "Episode.h"
#import <QuartzCore/QuartzCore.h>


// Default of 2. Might move this to 1, need to look into how NSMutableArray is implemented under the covers.
static NSUInteger kEpisodeArrayInitialCapacity = 2;

@implementation BILTVGuideEpisodeCell

@synthesize episodes = _episodes;
@synthesize currentEpisodeIndex = _episodeIndex;
@synthesize dateFormatter = _dateFormatter;

+ (UIFont *)headingFont {
    return [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
}

+ (UIFont *)subHeadingFont {
    return [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        _episodeIndex = 0;

        self.episodes = [NSMutableArray arrayWithCapacity:kEpisodeArrayInitialCapacity];
        
        // Set up the titles labels and styles.
        // Make the labels
        _currentTitle = [[UILabel alloc] init];
        _currentTitle.backgroundColor = [UIColor clearColor];
        _currentTitle.font = [[self class] headingFont];
        _currentTitle.textColor = [UIColor whiteColor];
    
        _currentSubtitle = [[UILabel alloc] init];
        _currentSubtitle.backgroundColor = [UIColor clearColor];
        _currentSubtitle.font = [[self class] subHeadingFont];
        _currentSubtitle.textColor = [UIColor whiteColor];
        
        _nextTitle = [[UILabel alloc] init];
        _nextTitle.backgroundColor = [UIColor clearColor];
        _nextTitle.font = [[self class] headingFont];
        _nextTitle.textColor = [UIColor whiteColor];
        
        _nextSubtitle = [[UILabel alloc] init];
        _nextSubtitle.backgroundColor = [UIColor clearColor];
        _nextSubtitle.font = [[self class] subHeadingFont];
        _nextSubtitle.textColor = [UIColor whiteColor];

        [self addSubview:_currentTitle];
        [self addSubview:_currentSubtitle];
        [self addSubview:_nextTitle];
        [self addSubview:_nextSubtitle];
        
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.backgroundView.frame = bounds;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundView.frame = self.bounds;
}

- (void)renderAndLayoutCurrentEpisodeWithYOffset:(int)yOffset {
    Episode* episode = nil;
    if ([_episodes count] > 0) {
        episode =[_episodes objectAtIndex:_episodeIndex];
    }
    
    _currentTitle.frame = CGRectMake(10, 2, 160, 20);
    if (episode) {
        _currentTitle.text = episode.title;
        [_currentTitle sizeToFit];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:episode.utcTimeStamp];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:episode.utcTimeOffset]];
        _currentSubtitle.text = [self.dateFormatter stringFromDate:date];
        _currentSubtitle.frame = CGRectMake(10, 22, 160, 20);
    }else{
        _currentTitle.text = @"Data unavailable";
        _currentSubtitle.text = nil;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self renderAndLayoutCurrentEpisodeWithYOffset:0];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)layoutSubviews {
    [self renderAndLayoutCurrentEpisodeWithYOffset:0];
}

- (void)clearEpisodes {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.episodes = nil;
    self.episodes = [NSMutableArray arrayWithCapacity:kEpisodeArrayInitialCapacity];
    _episodeIndex = 0;
}

- (void)addEpisode:(Episode *)episode {
    if (episode) {
        [self.episodes addObject:episode];
    }
}

#pragma mark - Updating

- (void)shouldRefreshCellIcons:(NSNotification*)notification {
    [self renderAndLayoutCurrentEpisodeWithYOffset:0];
}

#pragma mark - Scrolling

- (void)scrollSetup:(NSNotification*)n {
    if (self.episodes.count>1) {
        _episodeIndex = (_episodeIndex + 1) % self.episodes.count;
        
        UILabel* oldTitle = _currentTitle;
        _currentTitle = _nextTitle;
        _nextTitle = oldTitle;

        UILabel* oldSub = _currentSubtitle;
        _currentSubtitle = _nextSubtitle;
        _nextSubtitle = oldSub;
        
        [self renderAndLayoutCurrentEpisodeWithYOffset:-kProgramRowHeight];
    }
}

- (void)scrollEpisodes:(NSNotification *)notification {
    if (self.episodes.count>1) {
        _currentTitle.frame = CGRectOffset(_currentTitle.frame, 0, kProgramRowHeight);
        _currentSubtitle.frame = CGRectOffset(_currentSubtitle.frame, 0, kProgramRowHeight);
        _nextTitle.frame = CGRectOffset(_nextTitle.frame, 0, kProgramRowHeight);
        _nextSubtitle.frame = CGRectOffset(_nextSubtitle.frame, 0, kProgramRowHeight);
        _nextTitle.alpha = 0;
        _nextSubtitle.alpha = 0;
    }
}

- (void)scrollCleanup:(NSNotification *)notification {
    _nextTitle.alpha = 1.f;
    _nextSubtitle.alpha = 1.f;
    _currentTitle.alpha = 1.f;
    _currentSubtitle.alpha = 1.f;
}

- (void)clearForReuse {
    [self clearEpisodes];
}

- (void)displayEpisodeAtIndex:(NSInteger)index {
	_episodeIndex = index;
	[self renderAndLayoutCurrentEpisodeWithYOffset:-kProgramRowHeight * index];
}

#pragma mark - Highlight state

- (void)highlight {
    [super highlight];
    [_currentSubtitle setTextColor:[UIColor whiteColor]];
}

- (void)removeHighlight {
    [super removeHighlight];
    [_currentSubtitle setTextColor:[UIColor whiteColor]];
}


@end

