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

/**
 * The JSON URL request model class.
 * This class serves to handle the URL request to retrieve the TV Guide JSON, 
 * then parses the JSON and populate service objects and episode objects and act
 * as the data model for controller's manipulation.
 */
@interface BILTVGuideEpisodesRequestModel : NSObject<NSURLConnectionDataDelegate> {
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
