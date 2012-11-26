//
//  NSArray+Iteration.m
//  EventEmitter
//
//  Created by Samareh Booyachi on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Iteration.h"

@implementation NSArray(Iteration)

-(void)each:(void (^)(id elem))block {
    for (id element in self) {
        block(element);
    }
}

-(NSArray *)map:(id (^)(id elem))block {
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id element in self) {
        [returnArray addObject:block(element)];
    }
    return returnArray;
}

-(NSArray *)filter:(BOOL (^)(id elem))block {
    NSMutableArray* returnArray = [[NSMutableArray alloc] init];
    for (id element in self) {
        if (block(element)) {
            [returnArray addObject:element];
        }
    }
    return returnArray;
}

-(id)find:(BOOL (^)(id elem))block {
    for (id element in self) {
        if (block(element)) {
            return element;
        }
    }
    return nil;
}

-(id)reduce:(id (^)(id memo, id next))block initialValue:(id)initial {
    id memo = initial;
    for (id element in self) {
        memo = block(memo, element);
    }
    return memo;
}

@end
