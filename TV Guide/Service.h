//
//  Service.h
//  TV Guide
//
//  Created by Sai Tat Lam on 28/11/12.
//  Copyright (c) 2012 Bilue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject {
    @private
    NSString*           _serviceId;
    NSString*           _channelImage;
    NSString*           _serviceName;
    NSMutableArray*     _episodes;
}
@property (nonatomic, readonly) NSString*       serviceId;
@property (nonatomic, readonly) NSString*       channelImage;
@property (nonatomic, readonly) NSString*       serviceName;
@property (nonatomic, readonly) NSArray*        episodes;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
