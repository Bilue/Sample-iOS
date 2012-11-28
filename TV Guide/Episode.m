//
//  Episode.m
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import "Episode.h"

@implementation Episode

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if (self) {
        NSString* episodeId = [dictionary objectForKey:@"EpisodeId"];
        NSString* title = [dictionary objectForKey:@"Title"];
        NSString* episodeTitle = [dictionary objectForKey:@"EpisodeTitle"];
        NSString* synopsis = [dictionary objectForKey:@"Synopsis"];
        NSString* genre = [dictionary objectForKey:@"Genre"];
        NSString* highDefinition = [dictionary objectForKey:@"HighDefinition"];
        
        NSString* runningTime = [dictionary objectForKey:@"RunningTime"];
        NSString* rating = [dictionary objectForKey:@"Rating"];
        NSString* shareURL = [dictionary objectForKey:@"ShareUrl"];
        
        NSString* utcEventTimeStamp = [dictionary objectForKey:@"UtcEventTimestamp"];
        
        NSDate* startTime = [NSDate dateWithTimeIntervalSince1970:utcEventTimeStamp.integerValue];

        // Populate metadata for episode.
        _rating = [rating copy];
        _episodeId = [episodeId copy];
        _title = [title copy];
        if ([episodeTitle isKindOfClass:[NSString class]]) {
            _episodeTitle = [episodeTitle copy];
        }
        if ([synopsis isKindOfClass:[NSString class]]) {
            _synopsis = [synopsis copy];
        }
        _genre = [genre copy];
        _shareURL = [shareURL copy];
        _highDefinition = highDefinition.boolValue;
        _utcEventTimeStamp = startTime;
        _runningTime = runningTime.integerValue;
    }
    
    return self;
}

@end
