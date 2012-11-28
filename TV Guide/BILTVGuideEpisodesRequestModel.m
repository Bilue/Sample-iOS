//
//  BILTVGuideEpisodesRequestModel.m
//  TV Guide
//
//  Created by Sai Tat Lam on 28/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import "BILTVGuideEpisodesRequestModel.h"
#import "JSONKit.h"
#import "Service.h"

static const NSTimeInterval kURLRequestTimeoutInterval = 30.0f;

@interface BILTVGuideEpisodesRequestModel ()

@property (nonatomic, strong) NSURLConnection*  connection;
@property (nonatomic, strong) NSMutableData*    data;

@end

@implementation BILTVGuideEpisodesRequestModel

- (id)initWithURLPath:(NSString *)aUrlPath
{
    self = [self init];
    
    if (self) {
        self.urlPath = aUrlPath;
    }
    
    return self;
}

#pragma mark - Getters

- (NSArray *)services
{
    if (_services == nil) {
        _services = [NSMutableArray array];
    }
    
    return _services;
}

#pragma mark - Public methods

- (void)loadEpisodes
{
    [self loadEpisodesAtURLPath:self.urlPath];
}

- (void)loadEpisodesAtURLPath:(NSString *)urlPath
{
    
    NSURL *URL = [NSURL URLWithString:urlPath];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:kURLRequestTimeoutInterval];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    self.connection = urlConnection;
}

- (BOOL)isLoading
{
    return (self.connection != nil);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Obtain a JSON String.
    
    NSString *jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    if (jsonString.length > 0) {
        // Parse the JSON.
        NSDictionary *json = [jsonString objectFromJSONString];
        NSDictionary *tvListingList = [json objectForKey:@"TVListingList"];
        NSArray *services = [tvListingList objectForKey:@"Service"];
        
        _services = [NSMutableArray arrayWithCapacity:services.count];
        
        for (NSDictionary* serviceJSON in services) {
            Service* service = [[Service alloc] initWithDictionary:serviceJSON];
            
            [_services addObject:service];
        }
    }
    
    self.completionBlock();
    
    // Release reference to the connection we completed.
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

@end
