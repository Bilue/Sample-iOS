#import "Kiwi.h"
#import "BILTVGuideViewController.h"
#import "BILTVGuideGridView.h"
#import "BILTVGuideEpisodesRequestModel.h"

SPEC_BEGIN(BILTVGuideViewControllerSpec)

describe(@"BILTVGuideViewController", ^{
    context(@"loading the view", ^{
        BILTVGuideViewController* tvGuideViewController = [[BILTVGuideViewController alloc] initWithNibName:nil bundle:nil];
        
        it(@"should have the title TV Guide", ^{
            [tvGuideViewController viewDidLoad];
            
            [[tvGuideViewController.title should] equal:@"TV Guide"];
        });
    });
    
    context(@"displaying the view", ^{
        BILTVGuideViewController* tvGuideViewController = [[BILTVGuideViewController alloc] initWithNibName:nil bundle:nil];
        
        it(@"reload the grid view", ^{
            id mockGridView = [BILTVGuideGridView mock];
            tvGuideViewController.gridView = mockGridView;
            
            [[mockGridView should] receive:@selector(reloadData)];
            [tvGuideViewController viewWillAppear:NO];
        });
        
        it(@"should request data to make the TVGuide", ^{
            
            
            [[tvGuideViewController.episodesRequestModel.urlPath should] equal:@"http://jump-inapp.ninemsn.com.au/cache/region-73/listings-2012-11-29.json"];
            
            [[tvGuideViewController.episodesRequestModel should] beNonNil];
            
            [tvGuideViewController.episodesRequestModel loadEpisodes];
            
            // Test that we're firing off to fetch the TVGuideData here...
            [[theValue(tvGuideViewController.episodesRequestModel.isLoading) should] beTrue];
            
            // Test the JSON should actually gives back some services.
            [[expectFutureValue(theValue(tvGuideViewController.episodesRequestModel.services.count)) shouldEventually] beGreaterThan:theValue(0)];
            
            [tvGuideViewController viewWillAppear:NO];
        });
    });
});

SPEC_END