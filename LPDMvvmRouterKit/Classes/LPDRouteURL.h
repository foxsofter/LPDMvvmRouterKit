//
//  LPDRouteURL.h
//  LPDMvvmRouterKit
//
//  Created by fox softer on 17/2/11.
//
//

#import <Foundation/Foundation.h>

@interface LPDRouteURL : NSObject<NSCopying>

+ (instancetype)routerURLWithURL:(NSURL *)url;

+ (instancetype)routerURLWithString:(NSString *)URLString;

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithURLString:(NSString *)URLString;

@property (nonatomic, copy) NSString *scheme;

@property (nonatomic, copy) NSString *viewModel;

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSDictionary *parameters;

@property (nonatomic, strong, readonly) LPDRouteURL *callbackURL;

@end
