//
//  MI9TVGuideGridScrollView.h
//  Zeus_iPad
//
//  Created by Cameron Barrie on 2/06/12.
//  Copyright (c) 2012 MI9. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBILTVGuideDidFinishingLoading @"kBILTVGuideDidFinishingLoading"
#define kTvGuideCellsPixelsInset 1

@class BILTVGuideGridView;
@class BILTVGuideCell;

/* 
    This protocol is implemented by the controller to act as a data source
    to feed the grid view. Implement these methods to fill the grid view.
*/

@protocol BILTVGuideGridViewDataSource


@required
- (NSInteger)numberOfRowsInGridView:(BILTVGuideGridView *)gridView;
- (NSUInteger)numberOfCellsInRow:(NSUInteger)row;

- (BILTVGuideCell *)gridView:(BILTVGuideGridView *)gridView cellForIndexPath:(NSIndexPath *)indexPath;

- (CGRect)gridView:(BILTVGuideGridView *)gridView frameForCellAtIndexPath:(NSIndexPath *)indexPath;


- (CGFloat)gridView:(BILTVGuideGridView *)gridView heightForRowInSection:(NSUInteger)section;
- (CGFloat)widthForGridView:(BILTVGuideGridView *)gridView;

@end


/* 
    This protocol is implemented in order to allow selection of cells within the 
    TV Guide. These methods are modelled off those used by a UITableViewDelegate.
*/
@protocol BILTVGuideGridViewDelegate
@optional
- (BOOL)gridView:(BILTVGuideGridView *)gridView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gridView:(BILTVGuideGridView *)gridView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withCell:(BILTVGuideCell *)cell;

@end

/* 
 The TVGuide iteself, simply requires a dataSource, and for that dataSource
 to feed it with BILTVGuideCells for it to display. Simply set the dataSource
 and implement the dataSource methods and you should be off.
*/
@interface BILTVGuideGridView : UIScrollView

@property (nonatomic, weak) IBOutlet id<BILTVGuideGridViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<BILTVGuideGridViewDelegate, UIScrollViewDelegate> delegate;

- (void)reloadData;
- (BILTVGuideCell *)dequeueReusableCellWithIdentifier:(NSString *)name;
- (BILTVGuideCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForSelectedCell;
- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)deselectCell;

@end

@interface NSIndexPath (BILTVGuideGridView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)row inColumn:(NSInteger)column;

@property(nonatomic, readonly) NSInteger row;
@property(nonatomic, readonly) NSInteger column;

@end
