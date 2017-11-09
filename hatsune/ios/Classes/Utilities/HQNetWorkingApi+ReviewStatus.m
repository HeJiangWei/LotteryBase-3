//
//  HQNetWorkingApi+ReviewStatus.m
//  hatsune
//
//  Created by Mike on 21/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi+ReviewStatus.h"

@implementation HQNetWorkingApi (ReviewStatus)

+ (void)requestReviewInfoWithPlatform:(NSString *)platform channel:(NSString *)channel appUniqueId:(NSString *)uniqueId version:(NSString *)version handler:(ResponseHandler)handler {
    [HQNetworking getWithUrl:HQNetworkingReviewUrl paramsHandler:^(NSMutableDictionary *allHeaderFields, NSMutableDictionary *params) {
        params[@"platform"] = platform;
        params[@"channel"] = channel;
        params[@"appUniqueId"] = uniqueId;
        params[@"version"] = version;
    } handler:handler];
}

@end
