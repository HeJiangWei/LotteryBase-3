//
//  AppDelegate+Config.h
//  hatsune
//
//  Created by Mike on 17/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Config)

- (void)configWithSetttings;
- (void)showReactNativeControllerIfInNeed;
- (void)getKeysForCongfigrationWithHandler:(void(^)())handler;

@end
