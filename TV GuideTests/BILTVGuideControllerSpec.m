#import "Kiwi.h"
#import "BILTVGuideViewController.h"
#import "BILTVGuideGridView.h"

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
        
        pending(@"should request data to make the TVGuide", ^{
            // Should test that we're firing off to fetch the TVGuideData here...
            
            [tvGuideViewController viewWillAppear:NO];
        });
    });
});

SPEC_END