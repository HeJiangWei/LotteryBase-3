//
//  AppDelegate+Service.m
//  hatsune
//
//  Created by Mike on 17/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppDelegate+Service.h"

@implementation AppDelegate (Service)

- (void)configService {
    if (self.umengAppKey.length>0) {
        [self registerForUmentWithAppKey:self.umengAppKey];
    }
    if (self.jpushAppKey.length>0) {
        [self registerForJpushWithAppKey:self.jpushAppKey];
    }
}

- (void)registerForJpushWithAppKey:(NSString *)appKey {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:self.launchOptions
                           appKey:appKey
                          channel:@"App Store"
                 apsForProduction:YES];
}


/**
 注册友盟服务
 
 @param appKey 友盟key
 */
- (void)registerForUmentWithAppKey:(NSString *)appKey {
    //注册友盟推送
    [RCTUmengPush registerWithAppkey:appKey launchOptions:self.launchOptions];
    UMConfigInstance.appKey = appKey;
    UMConfigInstance.channelId = @"App Store";
    //  UMConfigInstance.eSType=E_UM_GAME;//友盟游戏统计，如不设置默认为应用统计
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setLogEnabled:YES];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    if (self.jpushAppKey.length>0) {
        // Required
        NSDictionary * userInfo = notification.request.content.userInfo;
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    if (self.jpushAppKey.length>0) {
        // Required
        NSDictionary * userInfo = response.notification.request.content.userInfo;
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler();  // 系统要求执行这个方法
    }
}

#pragma mark - application 

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (self.umengAppKey.length>0) {
        //获取deviceToken
        [RCTUmengPush application:application didRegisterDeviceToken:deviceToken];
    }
    
    if (self.jpushAppKey.length>0) {
        /// Required - 注册 DeviceToken
        [JPUSHService registerDeviceToken:deviceToken];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (self.umengAppKey.length>0) {
        //获取远程推送消息
        [RCTUmengPush application:application didReceiveRemoteNotification:userInfo];
    }
    
    if (self.jpushAppKey.length>0) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (self.jpushAppKey.length>0) {
        // Required, iOS 7 Support
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

@end
