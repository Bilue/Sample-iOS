//
//  MI9TVGuideCell.h
//  Zeus_iPad
//
//  Created by Cameron Barrie on 19/07/12.
//  Copyright (c) 2012 MI9. All rights reserved.
//

extern NSUInteger const kProgramRowHeight;

@interface BILTVGuideCell : UIView

@property (readonly,  strong) NSString* reuseIdentifier;
@property (nonatomic, strong) UIImageView* backgroundView;
@property (readwrite, strong) NSIndexPath *indexPath;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)highlight;
- (void)removeHighlight;
- (void)clearForReuse;
@end
