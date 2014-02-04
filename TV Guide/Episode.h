//
//  Episode.h
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject
@property (nonatomic, assign) NSUInteger       episodeId;
@property (nonatomic, strong) NSString*        title;
@property (nonatomic, assign) NSUInteger       runningTime;
@property (nonatomic, assign) NSTimeInterval   utcTimeStamp;
@property (nonatomic, assign) NSInteger        utcTimeOffset;

- (id)initWithDictionary:(NSDictionary*)JSONDictionary;

@end
