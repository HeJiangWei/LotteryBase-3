/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "AppDelegate+Service.h"
#import "AppDelegate+Config.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self configWithSetttings];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// ⚠️推送已经写好，禁止重写推送相关回调！！！如果集成别人代码过来的时候，记得将对方的推送相关内容去掉！

- (UIViewController *)nativeRootController {
    if (!_nativeRootController) {
        
        // TODO: ⚠️壳入口⚠️
        _nativeRootController = [[HomeViewController alloc] init];
        _nativeRootController.view.backgroundColor = [UIColor redColor];
    }
    return _nativeRootController;
}

@end
