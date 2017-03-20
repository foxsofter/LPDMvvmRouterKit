//
//  LPDModuleProtocol.h
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 16/11/9.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDEventProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDModuleProtocol <NSObject>

@optional

- (void)didLaunch:(id<LPDEventProtocol>)event;

- (void)willResignActive:(id<LPDEventProtocol>)event;

- (void)didEnterBackground:(id<LPDEventProtocol>)event;

- (void)willEnterBackground:(id<LPDEventProtocol>)event;

- (void)didBecomeActive:(id<LPDEventProtocol>)event;

- (void)willTerminate:(id<LPDEventProtocol>)event;

- (void)didReceiveMemoryWarning:(id<LPDEventProtocol>)event;

@end

NS_ASSUME_NONNULL_END
