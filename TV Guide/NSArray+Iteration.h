//
//  NSArray+Iteration.h
//  MI9Kit
//
//  Created by Samareh Booyachi on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Iteration)

-(void)each:(void (^)(id elem))block;
-(NSArray *)map:(id (^)(id elem))block;
-(NSArray *)filter:(BOOL (^)(id elem))block;
-(id)find:(BOOL (^)(id elem))block;
-(id)reduce:(id (^)(id memo, id next))block initialValue:(id)initial;

@end
