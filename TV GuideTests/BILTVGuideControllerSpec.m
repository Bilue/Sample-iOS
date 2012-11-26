#import "Kiwi.h"
#import "BILTVGuideViewController.h"

SPEC_BEGIN(BILTVGuideViewControllerSpec)

describe(@"BILTVGuideViewController", ^{
    context(@"loading the view", ^{
        BILTVGuideViewController* tvGuideViewController = [[BILTVGuideViewController alloc] initWithNibName:nil bundle:nil];
        pending(@"should request data to make the TVGuide", ^{
            // Should test that we're firing off to fetch the TVGuideData here...
            
            [tvGuideViewController viewDidLoad];

        });
        
        it(@"should have the title TV Guide", ^{
            [tvGuideViewController viewDidLoad];
            
            [[tvGuideViewController.title should] equal:@"TV Guide"];
        });
    });
});

SPEC_END