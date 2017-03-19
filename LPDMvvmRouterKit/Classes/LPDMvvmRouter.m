//
//  LPDMvvmRouter.m
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 16/11/9.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import "LPDMvvmRouter.h"
#import <objc/runtime.h>
#import <LPDMvvmKit/LPDMvvmKit.h>
#import "LPDConstant.h"
#import "UIViewController+LPDFinder.h"
#import "NSObject+LPDPerformAction.h"
#import "LPDRouteURL.h"
#import "LPDRuntime.h"
#import "LPDEventHandleProtocol.h"

@interface LPDMvvmRouter ()

@property (nonatomic, strong) NSMutableDictionary *viewModelClasses;
@property (nonatomic, strong) NSMutableDictionary *viewModelObjects;

@property (nonatomic, copy) NSDictionary *navigationActions;
@property (nonatomic, strong) NSMutableArray *moduleObjects;

@end

@implementation LPDMvvmRouter

static NSArray *allSchemes = nil;
+ (NSArray *)getAllSchemes {
  if (!allSchemes) {
    if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"]) {
      NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
      for(NSDictionary *urlType in urlTypes) {
        if(urlType[@"CFBundleURLSchemes"]) {
          allSchemes = urlType[@"CFBundleURLSchemes"];
        }
      }
    }
  }
  return allSchemes;
}

#pragma mark - life cycle

+ (instancetype)sharedInstance {
  static LPDMvvmRouter *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[LPDMvvmRouter alloc] init];
  });
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.navigationActions = @{ @"push" : @"pushViewModel:animated:",
                                @"pop" : @"popViewModelAnimated:",
                                @"popto" : @"popToViewModel:animated:",
                                @"poptoroot" : @"popToRootViewModelAnimated:",
                                @"present" : @"presentNavigationViewModel:animated:completion:",
                                @"dismiss" : @"dismissNavigationViewModelAnimated:completion:", };
    self.viewModelClasses = [NSMutableDictionary dictionary];
    self.viewModelObjects = [NSMapTable strongToWeakObjectsMapTable];
    [self loadModules];
    [self loadViewModels];
  }
  return self;
}

#pragma mark - public methods

- (BOOL)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  NSArray *allSchemes = [self.class getAllSchemes];
  if (![allSchemes containsObject:url.scheme]) {
    return NO;
  }

  return [self performActionWithUrl:url parameters:options completion:nil];
}

- (BOOL)performActionWithUrl:(NSURL *)url {
  return [self performActionWithUrl:url completion:nil];
}

- (BOOL)performActionWithUrl:(NSURL *)url completion:(void (^)(id))completion {
  return [self performActionWithUrl:url parameters:nil completion:completion];
}

- (BOOL)performActionWithUrl:(NSURL *)url
                  parameters:(NSDictionary<NSString *,id> *)parameters
                  completion:(void(^)(id x))completion {
  LPDRouteURL *routeURL = [LPDRouteURL routerURLWithURL:url];
  NSString *viewModelIdentifier = [NSString stringWithFormat:@"%@%@%@", routeURL.scheme, routeURL.viewModel, kLPDViewModelSuffix];
  Class viewModelClass = [self.viewModelClasses objectForKey:viewModelIdentifier];
  if (!viewModelClass) {
    return NO;
  }
  NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:routeURL.parameters];
  if (parameters) {
    [allParameters addEntriesFromDictionary:parameters];
  }
  NSString *action = [self.navigationActions objectForKey:routeURL.action];
  if (action) {
    NSObject *viewModel = [[viewModelClass alloc] init];
    NSPointerArray *viewModels = [self.viewModelObjects objectForKey:viewModelIdentifier];
    if (!viewModels) {
      viewModels = [NSPointerArray weakObjectsPointerArray];
      [self.viewModelObjects setObject:viewModels forKey:viewModelIdentifier];
    }
    [viewModels addPointer:(__bridge void * _Nullable)(viewModel)];
    NSObject *navigationViewModel = [self getTopNavigationViewModel];
    if (!navigationViewModel) {
      return NO;
    }

    NSNumber *animated = @YES;
    if (allParameters.count > 0) {
      [navigationViewModel setIvarValues:allParameters];
      animated = [allParameters objectForKey:@"animated"];
      if (animated) {
        [allParameters removeObjectForKey:@"animated"];
      }
    }
    
    [viewModel setIvarValues:allParameters];
    if ([routeURL.action isEqualToString:@"push"]) {
      NSDictionary *params = @{ @"pushViewModel" : viewModel, @"animated" : animated };
      [navigationViewModel performAction:action parameters:params completion:nil];
    } else if ([routeURL.action isEqualToString:@"pop"]) {
      NSDictionary *params = @{ @"popViewModelAnimated" : animated };
      [navigationViewModel performAction:action parameters:params completion:nil];
    } else if ([routeURL.action isEqualToString:@"popto"]) {
      NSDictionary *params = @{ @"popToViewModel" : viewModel, @"animated" : animated };
      [navigationViewModel performAction:action parameters:params completion:nil];
    } else if ([routeURL.action isEqualToString:@"poptoroot"]) {
      NSDictionary *params = @{ @"popToRootViewModelAnimated" : animated };
      [navigationViewModel performAction:action parameters:params completion:nil];
    } else if ([routeURL.action isEqualToString:@"present"]) {
      NSDictionary *params = nil;
      id presentNavigationViewModel = [[navigationViewModel.class alloc] initWithRootViewModel:viewModel];
      if (completion) {
        params = @{ @"presentNavigationViewModel" : presentNavigationViewModel,
                    @"animated" : animated,
                    @"completion" : ^{ completion(nil); } };
      } else {
        params = @{ @"presentNavigationViewModel" : presentNavigationViewModel,
                    @"animated" : animated };
      }
      [navigationViewModel performAction:action parameters:params completion:nil];
    } else if ([routeURL.action isEqualToString:@"dismiss"]) {
      NSDictionary *params = nil;
      if (completion) {
        params = @{ @"dismissNavigationViewModelAnimated" : animated,
                    @"completion" : ^{ completion(nil); } };
      } else {
        params = @{ @"dismissNavigationViewModelAnimated" : animated };
      }
      [navigationViewModel performAction:action parameters:params completion:nil];
    }
  } else {
    NSPointerArray *viewModels = [self.viewModelObjects objectForKey:viewModelIdentifier];
    if (viewModels) {
      [viewModels compact];
      [[viewModels allObjects] enumerateObjectsUsingBlock:^(NSObject * _Nonnull viewModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [viewModel performAction:routeURL.action parameters:allParameters completion:completion];
      }];
    }
  }

  return YES;
}

- (void)sendEvent:(id<LPDEventProtocol>)event {
  SEL eventSelector = NSSelectorFromString(event.eventSelector);
  [self.moduleObjects enumerateObjectsUsingBlock:^(id<LPDEventHandleProtocol>  _Nonnull module, NSUInteger idx,  BOOL * _Nonnull stop) {
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

- (void)loadViewModels {
  NSArray *viewModelClasses = getClassesMatching(^BOOL(Class cls) {
    return class_conformsToProtocol(cls, @protocol(LPDViewModelProtocol));
  });
  [viewModelClasses enumerateObjectsUsingBlock:^(Class cls, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *viewModelIdentifier = NSStringFromClass(cls).lowercaseString;
    [self.viewModelClasses setObject:cls forKey:viewModelIdentifier];
  }];
}

- (id<LPDNavigationViewModelProtocol>)getTopNavigationViewModel {
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  UIViewController *topNavigationController = [rootViewController getTopNavigationController];
  if (!topNavigationController) {
    return nil;
  }
  if (![topNavigationController isKindOfClass:LPDNavigationController.class]) {
    return nil;
  }
  return topNavigationController.viewModel;
}

- (void)loadModules {
  NSArray *moduleClasses = getClassesMatching(^BOOL(Class cls) {
    return [cls conformsToProtocol:@protocol(LPDEventHandleProtocol)];
  });
  [moduleClasses enumerateObjectsUsingBlock:^(Class  cls, NSUInteger idx, BOOL * _Nonnull stop) {
    [self.moduleObjects addObject:[[cls alloc] init]];
  }];
}

@end


