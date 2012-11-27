//
//  Episode.m
//  TV Guide
//
//  Created by Cameron Barrie on 26/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import "Episode.h"

@implementation Episode
- (id)initWithDictionary:(NSDictionary*)JSONDictionary {
    self = [super init];
    if (self) {
        self.episodeId = [[JSONDictionary objectForKey:@"EpisodeId"] integerValue];
        self.title = [JSONDictionary valueForKey:@"Title"];
        self.runningTime = [[JSONDictionary objectForKey:@"RunningTime"] integerValue];
        self.utcTimeStamp = [[JSONDictionary objectForKey:@"UtcEventTimestamp"] doubleValue];
        self.utcTimeOffset = [[JSONDictionary objectForKey:@"UtcOffset"] integerValue];
    }
    return self;
}
@end
