//
//  LPDEventHandleProtocol.h
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 16/11/9.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDEventProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDEventHandleProtocol <NSObject>

@optional

- (void)didLaunch:(id<LPDEventProtocol>)event;

- (void)willResignActive:(id<LPDEventProtocol>)event;

- (void)didEnterBackground:(id<LPDEventProtocol>)event;

- (void)willEnterBackground:(id<LPDEventProtocol>)event;

- (void)didBecomeActive:(id<LPDEventProtocol>)event;

- (void)willTerminate:(id<LPDEventProtocol>)event;

- (void)openURL:(id<LPDEventProtocol>)event;

- (void)didReceiveMemoryWarning:(id<LPDEventProtocol>)event;

- (void)didFailToRegisterForRemoteNotifications:(id<LPDEventProtocol>)event;

- (void)didRegisterForRemoteNotifications:(id<LPDEventProtocol>)event;

- (void)didReceiveRemoteNotification:(id<LPDEventProtocol>)event;

- (void)didReceiveLocalNotification:(id<LPDEventProtocol>)event;

- (void)didUpdateUserActivity:(id<LPDEventProtocol>)event;

- (void)willContinueUserActivity:(id<LPDEventProtocol>)event;

- (void)didFailToContinueUserActivity:(id<LPDEventProtocol>)event;

- (void)didContinueUserActivity:(id<LPDEventProtocol>)event;

@end

NS_ASSUME_NONNULL_END
