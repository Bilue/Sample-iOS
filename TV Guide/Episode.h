//
//  Episode.h
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject {
    NSString*           _episodeId;
    NSString*           _title;
    NSString*           _episodeTitle;
    NSString*           _synopsis;
    NSString*           _genre;
    NSString*           _rating;
    
    NSString*           _shareURL;
    NSInteger           _runningTime;
    BOOL                _highDefinition;
    
    NSDate*             _utcEventTimeStamp;
}

@property (nonatomic, readonly) NSString* episodeId;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* episodeTitle;
@property (nonatomic, readonly) NSString* synopsis;
@property (nonatomic, readonly) NSString* genre;
@property (nonatomic, readonly) NSString* rating;
@property (nonatomic, readonly) NSInteger runningTime;
@property (nonatomic, readonly) NSString* shareURL;
@property (nonatomic, readonly, getter = startTime) NSDate* utcEventTimeStamp;
@property (nonatomic, readonly, getter = isHighDefinition) BOOL highDefinition;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
