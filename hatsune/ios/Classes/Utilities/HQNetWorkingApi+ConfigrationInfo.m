//
//  HQNetWorkingApi+ConfigrationInfo.m
//  hatsune
//
//  Created by Mike on 21/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi+ConfigrationInfo.h"

@implementation HQNetWorkingApi (ConfigrationInfo)

+ (void)requestConfigInfoWithBundleID:(NSString *)bundleId handler:(ResponseHandler)handler {
    [HQNetworking getWithUrl:HQNetworkingConfigUrl paramsHandler:^(NSMutableDictionary *allHeaderFields, NSMutableDictionary *params) {
        params[@"appUniqueId"] = bundleId;
    } handler:handler];
}

+ (void)requestConfigInfohandler:(ResponseHandler)handler {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifer = [infoPlist objectForKey:@"CFBundleIdentifier"];
    [self requestConfigInfoWithBundleID:bundleIdentifer handler:handler];
}

@end
