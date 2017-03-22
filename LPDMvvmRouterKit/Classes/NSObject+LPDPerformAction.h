//
//  NSObject+LPDPerformAction.h
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/13.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LPDPerformAction)

- (void)performAction:(NSString *)actionName
           parameters:(nullable NSDictionary *)parameters
           completion:(void (^ __nullable)(__nullable id))completion;

- (void)setIvarValues:(NSDictionary<NSString *,id> *)parameters;

@end

NS_ASSUME_NONNULL_END
