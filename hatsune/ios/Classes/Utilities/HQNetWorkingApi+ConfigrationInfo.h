//
//  HQNetWorkingApi+ConfigrationInfo.h
//  hatsune
//
//  Created by Mike on 21/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi.h"

@interface HQNetWorkingApi (ConfigrationInfo)

+ (void)requestConfigInfoWithBundleID:(NSString *)bundleId handler:(ResponseHandler)handler;
+ (void)requestConfigInfohandler:(ResponseHandler)handler;

@end
