//
//  AppDelegate+Service.h
//  hatsune
//
//  Created by Mike on 17/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppDelegate.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "UMMobClick/MobClick.h"
#import "RCTUmengPush.h"

@interface AppDelegate (Service)<JPUSHRegisterDelegate>

- (void)configService;

- (void)registerForJpushWithAppKey:(NSString *)appKey;
- (void)registerForUmentWithAppKey:(NSString *)appKey;

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler;
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler;

@end
