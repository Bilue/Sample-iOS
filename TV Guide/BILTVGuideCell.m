//
//  MI9TVGuideCell.m
//  Zeus_iPad
//
//  Created by Cameron Barrie on 19/07/12.
//  Copyright (c) 2012 MI9. All rights reserved.
//

#import "BILTVGuideCell.h"
NSUInteger const kProgramRowHeight = 90;
NSUInteger const kTVGuideCellDefaultWidth = 220;

@implementation BILTVGuideCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize backgroundView = _backgroundView;
@synthesize indexPath = _indexPath;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:CGRectMake(0, 0, kTVGuideCellDefaultWidth, kProgramRowHeight)])) {
        _reuseIdentifier = reuseIdentifier;
        _backgroundView = [[UIImageView alloc] init];
        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)highlight {
    [self.backgroundView setHighlighted:YES];
}

- (void)removeHighlight {
    [self.backgroundView setHighlighted:NO];
}

- (void)clearForReuse {
    // No-op this is here for subclasses to implement
}



@end
