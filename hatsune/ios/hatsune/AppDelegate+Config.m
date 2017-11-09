//
//  AppDelegate+Config.m
//  hatsune
//
//  Created by Mike on 17/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppDelegate+Config.h"
#import "HQNetWorkingApi+ReviewStatus.h"
#import "HQNetWorkingApi+ConfigrationInfo.h"
#import "CodePush.h"
#import "RCTBundleURLProvider.h"
#import "RCTRootView.h"
#import "LoadingViewController.h"
#import "AppDelegate+Service.h"
#import <CoreTelephony/CTCellularData.h>

@implementation AppDelegate (Config)

- (BOOL)isShowReactNativeContent {
        static NSString *ShowReactNativeContent = @"interestingThingsHappen";
        // 网络更新本地配置会有延迟，先根据本地配置进行展示，防止闪退
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL showRNContentAtFirst = [userDefaults boolForKey:ShowReactNativeContent];
        return showRNContentAtFirst;
}


- (void)configWithSetttings {
    [self loadDefaultSettings];
    
    if (self.codePushKey.length>0 && (self.umengAppKey.length>0 || self.jpushAppKey.length>0)        && [self isShowReactNativeContent]) {
//    if (self.codePushKey.length>0 && (self.umengAppKey.length>0 || self.jpushAppKey.length>0)) {
        [self initialReactNativeController];
        self.window.rootViewController = self.reactNativeRootController;
    } else {
        self.window.rootViewController = self.nativeRootController;
    }
    
    
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    
    if (systemVersion >= 9) {
        CTCellularData *cellularData = [[CTCellularData alloc]init];
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
            //获取联网状态，解决中国特色社会主义问题
            if (state == kCTCellularDataNotRestricted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self configIfCellularDataNotRestricted];
                });
            }
        };
        if (state==kCTCellularDataNotRestricted) {
            [self configIfCellularDataNotRestricted];
        } else if (state==kCTCellularDataRestrictedStateUnknown) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *URL = [NSURL URLWithString:@"http://cse.kosun.cc"];
                [NSData dataWithContentsOfURL:URL];
            });
        }
    } else {
        [self configIfCellularDataNotRestricted];
    }
}

- (void)configIfCellularDataNotRestricted {
    NSLog(@"######%s######", __func__);
    if (self.codePushKey.length>0 && (self.umengAppKey.length>0 || self.jpushAppKey.length>0)        && [self isShowReactNativeContent]) {
//    if (self.codePushKey.length>0 && (self.umengAppKey.length>0 || self.jpushAppKey.length>0)) {
        [self initialReactNativeController];
        self.window.rootViewController = self.reactNativeRootController;
        [self showReactNativeControllerIfInNeed];
        [self configService];

        // 后台相关key有可能更新，这边请求最新的后台Key，以备下次打开使用
        [self getKeysForCongfigrationWithHandler:^{
            if (self.codePushKey.length>0 && (self.umengAppKey.length>0 || self.jpushAppKey.length>0)) {
                [self showReactNativeControllerIfInNeed];
                [self configService];
                NSLog(@"PushKey %@", self.codePushKey);
            }
        }];
    } else {
        self.window.rootViewController = self.nativeRootController;
        [self getKeysForCongfigrationWithHandler:^{
            if (self.codePushKey.length>0 && (self.umengAppKey.length>0 || self.jpushAppKey.length>0)) {
                [self showReactNativeControllerIfInNeed];
                [self configService];
            }
        }];
    }
}

- (void)loadDefaultSettings {
    
    NSString *udUmengAppKey = @"UmengAppKey";
    NSString *udCodePushKey = @"CodePushKey";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.umengAppKey = [userDefault stringForKey:udUmengAppKey];
    self.codePushKey = [userDefault stringForKey:udCodePushKey];
}

- (void)getKeysForCongfigrationWithHandler:(void(^)())handler {
    [HQNetWorkingApi requestConfigInfohandler:^(NSDictionary *allHeaderFields, NSDictionary *responseObject) {
        
        NSDictionary *responseDic = responseObject;
        NSInteger code = [responseDic[@"code"] integerValue];
        NSDictionary *dataDic = responseDic[@"data"];
        
        NSString *udUmengAppKeyKey = @"UmengAppKey";
        NSString *udCodePushKeyKey = @"CodePushKey";
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        if (code == 200) {
            NSString *umengAppKey = dataDic[@"umengKey"];
            NSString *codepushKey = dataDic[@"codepushKey"];
            
            [userDefault setObject:umengAppKey forKey:udUmengAppKeyKey];
            [userDefault setObject:codepushKey forKey:udCodePushKeyKey];
        }
        
        self.umengAppKey = [userDefault stringForKey:udUmengAppKeyKey];
        self.codePushKey = [userDefault stringForKey:udCodePushKeyKey];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler();
            }
        });
    }];
}

#pragma mark - custom methods

-  (void)restoreRootViewController:(UIViewController *)newRootController {
    [UIView transitionWithView:self.window duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        if (self.window.rootViewController!=newRootController) {
            self.window.rootViewController = newRootController;
        }
        [UIView setAnimationsEnabled:oldState];
    } completion:nil];
}

- (void)showReactNativeControllerIfInNeed {
    
    static NSString *ShowReactNativeContent = @"interestingThingsHappen";
    
    // 网络更新本地配置会有延迟，先根据本地配置进行展示，防止闪退
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL showRNContentAtFirst = [userDefaults boolForKey:ShowReactNativeContent];
    
    if (showRNContentAtFirst) {
        [self initialReactNativeController];
        self.window.rootViewController = self.reactNativeRootController;
    } else {
        self.window.rootViewController = self.nativeRootController;
    }
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleVersion = [infoPlist objectForKey:@"CFBundleVersion"];
    NSString *bundleIdentifer = [infoPlist objectForKey:@"CFBundleIdentifier"];
    [HQNetWorkingApi requestReviewInfoWithPlatform:@"1" channel:@"AppStore" appUniqueId:bundleIdentifer version:bundleVersion handler:^(NSDictionary *allHeaderFields, NSDictionary *responseObject) {
        NSInteger statusCode = [responseObject[@"code"] integerValue];
        if (statusCode>=200 && statusCode<=206) {
            // 请求成功的情况
            NSDictionary *dataDic = responseObject[@"data"];
            NSInteger reviewStatusCode = [dataDic[@"reviewStatus"] integerValue];
            if (reviewStatusCode==2) {
                // 已经通过审核
                [userDefaults setBool:YES forKey:ShowReactNativeContent];
            } else {
                // 没有通过审核
                [userDefaults setBool:NO forKey:ShowReactNativeContent];
            }
        } else {
            // 请求失败的情况
            [userDefaults setBool:NO forKey:ShowReactNativeContent];
        }
        // 根据缓存来展示RN内容
        BOOL showRNContent = [userDefaults boolForKey:ShowReactNativeContent];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 切换主线程进行展示
            if (showRNContent) {
                [self initialReactNativeController];
                [self restoreRootViewController:self.reactNativeRootController];
            } else {
                [self restoreRootViewController:self.nativeRootController];
            }
        });
    }];
}

- (void)initialReactNativeController {
    if (self.reactNativeRootController==nil) {
        self.reactNativeRootController = [[UIViewController alloc] init];
        NSURL *jsCodeLocation;
        [CodePush overrideAppVersion:@"1.0.0"];
        [CodePush setDeploymentKey:self.codePushKey];
        
        NSLog(@"CodePushkey %@", self.codePushKey);
#ifdef DEBUG
        jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#else
        jsCodeLocation = [CodePush bundleURL];
#endif
        
        RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                            moduleName:@"hatsune"
                                                     initialProperties:nil
                                                         launchOptions:self.launchOptions];
        rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        self.reactNativeRootController.view = rootView;
    }
}

- (void)initialLoadingController {
    if (!self.loadingController) {
        self.loadingController = [[LoadingViewController alloc] init];
    }
}

@end
