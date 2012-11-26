#import "Kiwi.h"
#import "NSArray+Iteration.h"

SPEC_BEGIN(NSArray_IterationSpec)


describe(@"NSArray Iteration", ^{
    context(@"Map", ^{
        it(@"should alter all the values in the array", ^{
            NSArray* upperCaseArray = [@[@"one", @"two"] map:^id(NSString* string) {
                return [string uppercaseString];
            }];
            
            [[upperCaseArray[0] should] equal:@"ONE"];
            [[upperCaseArray[1] should] equal:@"TWO"];
        });
    });
    
    context(@"Filter", ^{

    });
    
    context(@"Each", ^{

    });
    
    context(@"Find", ^{

    });
    
    context(@"Reduce", ^{

    });
});

SPEC_END