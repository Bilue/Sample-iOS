//
//  Service.m
//  TV Guide
//
//  Created by Sai Tat Lam on 28/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import "Service.h"
#import "Episode.h"

@interface Service ()

@end

@implementation Service

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    if (self) {
        _episodes = [NSMutableArray array];
        
        NSDictionary *tvListingsJSON = [dictionary objectForKey:@"TVListings"];
        NSArray *tvListingJSONs = [tvListingsJSON objectForKey:@"TVListing"];
        
        NSString *serviceName = [dictionary objectForKey:@"ServiceName"];
        NSString *serviceId = [dictionary objectForKey:@"ServiceId"];
        
        // Populate the metadata...
        _serviceName = [serviceName copy];
        _serviceId = [serviceId copy];
        
        // Instantiates the episodes belonging to this service.
        for (NSDictionary *tvListingJSON in tvListingJSONs) {
            Episode *episode = [[Episode alloc] initWithDictionary:tvListingJSON];
            
            [_episodes addObject:episode];
        }
    }
    
    return self;
}

#pragma mark - Getters

- (NSArray *)episodes
{
    if (_episodes == nil) {
        _episodes = [NSMutableArray array];
    }
    return _episodes;
}

@end
