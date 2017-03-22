//
//  LPDMvvmRouter.h
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 16/11/9.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LPDRouteURL.h"

NS_ASSUME_NONNULL_BEGIN

/**
 router
 action —— scheme://[viewModel]/[action]?[parameters]
 */
@interface LPDMvvmRouter : NSObject

+ (instancetype)sharedInstance;

/**
 Inter-app invoke.
 
 @param url scheme://[...][viewModel]/[action]?[parameters]
 @param options dictionary of URL handling options
 @return YES if successfully handled or NO if failed for some reason.
 */
- (BOOL)openURL:(NSURL *)url options:(nullable NSDictionary<NSString *, id> *)options;

/**
 In-app invoke.
 
 @param url scheme://[viewModel]/[action]?[parameters]
 @return YES if successfully handled or NO if failed for some reason.
 */
- (BOOL)performActionWithUrl:(LPDRouteURL *)url;

/**
 In-app invoke.
 
 @param url scheme://[viewModel]/[action]?[parameters]
 @param completion callback block, the parameter x represents return value of action.
 @return YES if successfully handled or NO if failed for some reason.
 */
- (BOOL)performActionWithUrl:(LPDRouteURL *)url completion:(nullable void(^)(__nullable id x))completion;

/**
 In-app invoke.
 
 @param url scheme://[viewModel]/[action]?[parameters]
 @param parameters Parameter type could be
 @param completion callback block, the parameter x represents return value of action.
 @return YES if successfully handled or NO if failed for some reason.
 */
- (BOOL)performActionWithUrl:(LPDRouteURL *)url parameters:(nullable  NSDictionary<NSString *, id> *)parameters completion:(nullable void(^)(__nullable id x))completion;

@end

NS_ASSUME_NONNULL_END
