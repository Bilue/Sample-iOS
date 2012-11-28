//
//  BILTVGuideEpisodesRequestModel.h
//  TV Guide
//
//  Created by Sai Tat Lam on 28/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BILTVGuideEpisodesRequestCompletionBlock)(void);

@class Episode;

@interface BILTVGuideEpisodesRequestModel : NSObject<NSURLConnectionDataDelegate> {
    @private
    
    NSString*                   _urlPath;
    NSURLConnection*            _connection;
    NSMutableData*              _data;
    
    NSMutableArray*             _services;
    
    BILTVGuideEpisodesRequestCompletionBlock       _completionBlock;
}

@property (nonatomic, copy) NSString* urlPath;
@property (nonatomic, readonly) NSArray* services;
@property (nonatomic, copy) BILTVGuideEpisodesRequestCompletionBlock completionBlock;

- (id)initWithURLPath:(NSString *)aUrlPath;

/**
 * Perform URL request to retrieve episodes JSON using object's default urlPath.
 */
- (void)loadEpisodes;

/**
 * Perform URL request to retrieve episodes JSON with a given URL Path.
 */
- (void)loadEpisodesAtURLPath:(NSString *)urlPath;

/**
 * Checks if there is an active URL connection.
 */
- (BOOL)isLoading;

@end
