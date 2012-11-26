//
//  MI9TVGuideGridScrollView.m
//  Zeus_iPad
//
//  Created by Cameron Barrie on 2/06/12.
//  Copyright (c) 2012 MI9. All rights reserved.

#import "BILTVGuideGridView.h"
#import "BILTVGuideCell.h"
#import "NSArray+Iteration.h"

// Custom NSIndexPath implementation.
@implementation NSIndexPath (BILTVGuideGridView)

- (NSInteger)column {
    return [self indexAtPosition:1];
}

- (NSInteger)row {
    return [self indexAtPosition:0];
}

+ (NSIndexPath *)indexPathForRow:(NSInteger)row inColumn:(NSInteger)column {
    NSUInteger indexArr[] = {row, column};
    return [self indexPathWithIndexes:indexArr length:2];
}

@end



@interface BILTVGuideGridView ()

@property (nonatomic, strong) BILTVGuideCell *highlightedCell;

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) NSUInteger standardRowHeight;

@property (nonatomic, strong) NSMutableDictionary *reusableTableCells;
@property (nonatomic, strong) NSMutableDictionary *visibleCells;

- (CGRect)cacheCellBounds;

@end


@implementation BILTVGuideGridView

@dynamic delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        self.reusableTableCells = [NSMutableDictionary dictionary];
        self.visibleCells = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setHighlightedCell:(BILTVGuideCell*)highlightedCell {
	if (_highlightedCell != highlightedCell) {
		// Clear the old selection
		[_highlightedCell removeHighlight];
		_highlightedCell = highlightedCell;
		[_highlightedCell highlight];
	}
}

- (NSIndexPath *)indexPathForSelectedCell {
	return self.highlightedCell.indexPath;
}

- (BILTVGuideCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
	BILTVGuideCell *cell = [self.visibleCells objectForKey:indexPath];
	if (!cell) {
		cell = [self.dataSource gridView:self cellForIndexPath:indexPath];
        if (cell) {
            cell.indexPath = indexPath;
            [self.visibleCells setObject:cell forKey:indexPath];
        }
	}
	return cell;
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
	self.highlightedCell = [self cellAtIndexPath:indexPath];
}

- (void)deselectCell {
    self.highlightedCell = nil;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    UIView* touchedView = [[touches anyObject] view];
    if ([touchedView respondsToSelector:@selector(indexPath)]) {
        if ([self.delegate respondsToSelector:@selector(gridView:willSelectRowAtIndexPath:)]) {
            return [self.delegate gridView:self willSelectRowAtIndexPath:[(BILTVGuideCell *)touchedView indexPath]];
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView* view = [[touches anyObject] view];
    if ([view respondsToSelector:@selector(indexPath)]) {
        self.highlightedCell = (BILTVGuideCell*)view;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView* view = [[touches anyObject] view];
    if ([view respondsToSelector:@selector(indexPath)]) {
        BILTVGuideCell* cell = (BILTVGuideCell *)view;
        [self.delegate gridView:self didSelectRowAtIndexPath:cell.indexPath withCell:cell];
    }    
}

- (BILTVGuideCell *)dequeueReusableCellWithIdentifier:(NSString *)name {
    NSMutableArray* cells = [self.reusableTableCells objectForKey:name];
    BILTVGuideCell* cell = nil;
    if ([cells count] > 0) {
        cell = [cells objectAtIndex:0];
        [cells removeObject:cell];
    }
    
    return cell;
}

// Remove cache and clean...
- (void)reloadData {
    self.numberOfRows = [self.dataSource numberOfRowsInGridView:self];
    self.standardRowHeight = [self.dataSource gridView:self heightForRowInSection:0];
	self.contentSize = CGSizeMake([self.dataSource widthForGridView:self], self.standardRowHeight * self.numberOfRows);
    
	for (NSIndexPath *indexPath in [self.visibleCells copy]) {
		BILTVGuideCell *cell = [self.visibleCells objectForKey:indexPath];
		[cell removeFromSuperview];
		[self enqueueCellForReuse:cell];
	}
    [self setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBILTVGuideDidFinishingLoading object:nil userInfo:nil];
}

- (void)enqueueCellForReuse:(BILTVGuideCell*)cell {
    [cell clearForReuse];
	[self.visibleCells removeObjectForKey:cell.indexPath];
    NSMutableArray* reusableCells = [self.reusableTableCells valueForKey:cell.reuseIdentifier];
    if (!reusableCells) {
        NSMutableArray* cells = [NSMutableArray arrayWithObject:cell];
        [self.reusableTableCells setValue:cells forKey:cell.reuseIdentifier];
    } else {
        [reusableCells addObject:cell];
    }
}

- (CGRect)cacheCellBounds {
	return self.bounds;
}

- (void)enqueueCellsForReuseWithinBounds:(CGRect)cacheCellBounds {
	NSSet *cells = [NSSet setWithArray:[self.visibleCells allValues]];
    NSArray* cellsForReuse = [[self subviews] filter:^BOOL(UIView* cell) {
        return [cells containsObject:cell] && !(CGRectIntersectsRect(cacheCellBounds, cell.frame));
    }];
    for (BILTVGuideCell* cell in cellsForReuse) {
        [cell removeFromSuperview];
        [self enqueueCellForReuse:cell];
    }
}

- (void)layoutSubviews {
    CGRect cacheCellBounds = [self cacheCellBounds];
    [self enqueueCellsForReuseWithinBounds:cacheCellBounds];
	
	CGFloat height = 0;
    for (int rowNumber = 0; rowNumber < self.numberOfRows; rowNumber++) {
		CGFloat heightOfRow = [self.dataSource gridView:self heightForRowInSection:rowNumber];
        CGFloat rowYMin = heightOfRow * rowNumber;
		CGFloat rowYMax = rowYMin + heightOfRow;
        if (rowYMax > cacheCellBounds.origin.y && rowYMin < CGRectGetMaxY(cacheCellBounds)) {
            NSUInteger numberOfCells = [self.dataSource numberOfCellsInRow:rowNumber];
            for (int cellNumber = 0; cellNumber < numberOfCells; cellNumber++) {
                @autoreleasepool {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:cellNumber inSection:rowNumber];
					CGRect cellFrame = [self.dataSource gridView:self frameForCellAtIndexPath:indexPath];
					
					if (CGRectIntersectsRect(cacheCellBounds, cellFrame)) {
						BILTVGuideCell *cell = [self cellAtIndexPath:indexPath];
						if (cell && !cell.superview) {
							cell.frame = CGRectInset(cellFrame, kTvGuideCellsPixelsInset, kTvGuideCellsPixelsInset);
							[self insertSubview:cell atIndex:0];
						}
					} // Cell intersects rect
                } // Autorelease
            } // Cells
        } // Row Exists in CacheBounds
		height += heightOfRow;
    } // Rows
	
	// Update the height of the content size to take into account any rows with different heights
	self.contentSize = CGSizeMake(self.contentSize.width, height);
}

@end
