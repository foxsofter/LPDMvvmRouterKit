//
//  LPDModuleMediator.m
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/19.
//
//

#import "LPDModuleMediator.h"
#import "LPDModuleProtocol.h"
#import "LPDRuntime.h"
#import "LPDEvent.h"

@interface LPDModuleMediator ()

@property (nonatomic, strong) NSMutableArray *moduleObjects;
@property (nonatomic, strong) NSMutableArray *observers;
@property (nonatomic, strong) NSDictionary *eventNotificationMaps;

@end

@implementation LPDModuleMediator

#pragma mark - life cycle

+ (instancetype)sharedInstance {
  static LPDModuleMediator *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[LPDModuleMediator alloc] init];
  });
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _eventNotificationMaps =
    @{ kEventDidLaunch : UIApplicationDidFinishLaunchingNotification,
       kEventWillResignActive : UIApplicationWillResignActiveNotification,
       kEventWillEnterForeground : UIApplicationWillEnterForegroundNotification,
       kEventDidEnterBackground : UIApplicationDidEnterBackgroundNotification,
       kEventDidBecomeActive : UIApplicationDidBecomeActiveNotification,
       kEventWillTerminate : UIApplicationWillTerminateNotification,
       kEventDidReceiveMemoryWarning : UIApplicationDidReceiveMemoryWarningNotification,};
    
    [self loadModules];
  }
  return self;
}

- (void)sendEvent:(id<LPDEventProtocol>)event {
  SEL eventSelector = NSSelectorFromString(event.eventSelector);
  [self.moduleObjects enumerateObjectsUsingBlock:^(id<LPDModuleProtocol>  _Nonnull module, NSUInteger idx,  BOOL * _Nonnull stop) {
    if ([module respondsToSelector:eventSelector]) {
      if (event.async) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [module performSelector:eventSelector withObject:event];
        });
      } else {
        [module performSelector:eventSelector withObject:event];
      }
    }
  }];
}

#pragma mark - private methods

- (void)loadModules {
  NSArray *moduleClasses = getClassesMatching(^BOOL(Class cls) {
    return [cls conformsToProtocol:@protocol(LPDModuleProtocol)];
  });
  self.moduleObjects = [NSMutableDictionary dictionary];
  [moduleClasses enumerateObjectsUsingBlock:^(Class  cls, NSUInteger idx, BOOL * _Nonnull stop) {
    [self.moduleObjects addObject:[[cls alloc] init]];
  }];
}

- (void)observerAppLifecycle {
  [self.eventNotificationMaps enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
    id observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:value object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
      LPDEvent *event = [LPDEvent eventWithEventSelector:key];
      event.async = [key isEqualToString:kEventDidLaunch];
      event.eventArgs = notification.userInfo;
      [[LPDModuleMediator sharedInstance] sendEvent:event];
    }];
    [self.observers addObject:observer];
  }];
}

- (void)dealloc {
  [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull observer, NSUInteger idx, BOOL * _Nonnull stop) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
  }];
}

@end
