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
#import "AFNetworking.h"
#import "Episode.h"

static NSString* const feedURLStr = @"http://jump-inapp.ninemsn.com.au/cache/region-73/listings-2012-11-29.json";

#define kCellWidthFactor  4

@interface BILTVGuideViewController (){
    AFJSONRequestOperation* _requestOperation;
    NSMutableArray*         _tvServices;
    NSUInteger              _maxRunningTime;
}

@end

@implementation BILTVGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.title = @"TVGuide";
    NSURL* url = [NSURL URLWithString:feedURLStr];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    __weak BILTVGuideViewController* weakSelf = self;
    _requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (response.statusCode == 200 || response.statusCode == 201) {
            [weakSelf buildTVGuidDataFromJSONObj:JSON];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.gridView = [[BILTVGuideGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                weakSelf.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                weakSelf.gridView.dataSource = self;
                weakSelf.gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
                [weakSelf.view addSubview:self.gridView];
                [weakSelf.gridView reloadData];
                [weakSelf.activityIndicator stopAnimating];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showErrorAlertWithMessage:@"Failed to get TV guid from server"];
            });
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf showErrorAlertWithMessage:[error localizedDescription]];
        });
    }];
    [_requestOperation start];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    return _maxRunningTime*kCellWidthFactor;
}

- (NSInteger)numberOfRowsInGridView:(BILTVGuideGridView *)gridView {
    return [_tvServices count];
}

- (NSUInteger)numberOfCellsInRow:(NSUInteger)row {
    return [[_tvServices objectAtIndex:row] count];
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
    cell.episodes = [@[[[_tvServices objectAtIndex:indexPath.row] objectAtIndex:indexPath.column]] mutableCopy];
    
    return cell;
}

- (CGRect)gridView:(BILTVGuideGridView *)gridView frameForCellAtIndexPath:(NSIndexPath *)indexPath {
    static CGFloat startX = 0;
    Episode* episode = [[_tvServices objectAtIndex:indexPath.row] objectAtIndex:indexPath.column];
    if (indexPath.column == 0) {
        startX = 0;
    }
    CGRect frame = CGRectMake(startX, 44 * indexPath.row, episode.runningTime*kCellWidthFactor, 44);
    startX += episode.runningTime*kCellWidthFactor;
    return frame;
}

#pragma mark - build TV Guid Data
- (void)buildTVGuidDataFromJSONObj:(NSDictionary*)JSONObj {

    NSDictionary* tvListListing = [JSONObj objectForKey:@"TVListingList"];
    NSArray* tvServices = [tvListListing objectForKey:@"Service"];
    _tvServices = [[NSMutableArray alloc] initWithCapacity:tvServices.count];
    [tvServices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        __block NSUInteger sumRunningTime = 0;
        NSDictionary* tvListings = [(NSDictionary*)obj objectForKey:@"TVListings"];
        NSArray* tvListing = [tvListings objectForKey:@"TVListing"];
        NSMutableArray* tvEpisods = [[NSMutableArray alloc] initWithCapacity:tvListing.count];
        [tvListing enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Episode* episode = [[Episode alloc] initWithDictionary:obj];
            [tvEpisods addObject:episode];
            sumRunningTime += episode.runningTime;
        }];
        if (_maxRunningTime < sumRunningTime) {
            _maxRunningTime = sumRunningTime;
        }
        [_tvServices addObject:tvEpisods];
    }];
}
                         
#pragma mark - Error AlertView
// ! I prefer HUD just like toast view in android, but use alertView for simple
- (void)showErrorAlertWithMessage:(NSString*)msg {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


@end
