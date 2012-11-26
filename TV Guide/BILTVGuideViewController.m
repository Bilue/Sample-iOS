//
//  BILViewController.m
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import "BILTVGuideViewController.h"
#import "BILTVGuideEpisodeCell.h"
#import "BILTVGuideGridView.h"

@interface BILTVGuideViewController ()

@end

@implementation BILTVGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TVGuide";
    self.gridView = [[BILTVGuideGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.dataSource = self;
    self.gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [self.view addSubview:self.gridView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.gridView reloadData];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"h:mm a";
    }
    return _dateFormatter;
}

- (CGFloat)gridView:(BILTVGuideGridView *)gridView heightForRowInSection:(NSUInteger)section {
    return 44.f;
}

- (CGFloat)widthForGridView:(BILTVGuideGridView *)gridView {
    return 10000.f;
}

- (NSInteger)numberOfRowsInGridView:(BILTVGuideGridView *)gridView {
    return 16;
}

- (NSUInteger)numberOfCellsInRow:(NSUInteger)row {
    return 50;
}

- (BILTVGuideCell *)gridView:(BILTVGuideGridView *)gridView cellForIndexPath:(NSIndexPath *)indexPath {
    static  NSString* episodeCell = @"episodeCell";

    BILTVGuideEpisodeCell* cell = (BILTVGuideEpisodeCell *)[self.gridView dequeueReusableCellWithIdentifier:episodeCell];
    if (cell == nil) {
        cell = [[BILTVGuideEpisodeCell alloc] initWithReuseIdentifier:episodeCell];
        cell.dateFormatter = self.dateFormatter;
        cell.backgroundView.image = [[UIImage imageNamed:@"tv-guide-cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(44, 5, 44, 5)];
        cell.backgroundView.highlightedImage = [[UIImage imageNamed:@"tv-guide-cell-active"] resizableImageWithCapInsets:UIEdgeInsetsMake(44, 5, 44, 5)];
    }
    
    // Add episodes to the cell here...
    
    return cell;
}

- (CGRect)gridView:(BILTVGuideGridView *)gridView frameForCellAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectMake(200 * indexPath.column, 44 * indexPath.row, 200, 44);
}

@end
