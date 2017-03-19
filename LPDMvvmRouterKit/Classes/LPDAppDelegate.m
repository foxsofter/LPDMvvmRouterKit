//
//  LPDAppDelegate.m
//  Pods
//
//  Created by foxsofter on 17/3/8.
//
//

#import "LPDAppDelegate.h"
#import "LPDEvent.h"
#import "LPDConstant.h"

@implementation LPDxAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  LPDEvent *moduleEvent = [LPDEvent eventWithEventSelector:kEventDidLaunch];
  moduleEvent.eventArgs = launchOptions;
  moduleEvent.async = YES;
//  [[LPDModuleMediator sharedInstance] sendModuleEvent:moduleEvent];
  return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
  
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
  
  return YES;
}
#endif


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){

  }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){

  }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){

  }
  return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
  if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){

  }
  return YES;
}

#endif

@end
