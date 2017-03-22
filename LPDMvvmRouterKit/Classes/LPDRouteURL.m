//
//  LPDRouteURL.m
//  LPDMvvmRouterKit
//
//  Created by fox softer on 17/2/11.
//
//

#import "LPDRouteURL.h"

@interface LPDRouteURL ()

@property (nonatomic, strong) NSURLComponents *components;

@end

@implementation LPDRouteURL

#pragma mark - initial methods

+ (instancetype)routerURLWithURL:(NSURL *)url {
  return [[self alloc] initWithURL:url];
}

+ (instancetype)routerURLWithString:(NSString *)URLString {
  return [[self alloc] initWithURLString:URLString];
}

- (instancetype)initWithURL:(NSURL *)url {
  if (self = [super init]) {
    self.components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
  }
  return self;
}

- (instancetype)initWithURLString:(NSString *)URLString {
  if (self = [super init]) {
    NSURL *url = [NSURL URLWithString:URLString];
    self.components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
  }
  return self;
}


- (NSString *)scheme {
  return self.components.scheme;
}

- (void)setScheme:(NSString *)scheme {
  self.components.scheme = scheme;
}

- (NSString *)viewModel {
  return self.components.host;
}

- (void)setViewModel:(NSString *)viewModel {
  self.components.host = viewModel;
}

- (NSString *)action {
  return [self.components.path substringFromIndex:1];
}

- (void)setAction:(NSString *)action {
  self.components.path = [NSString stringWithFormat:@"/%@", action];
}

- (NSDictionary *)parameters {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  [self.components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull queryItem, NSUInteger idx, BOOL * _Nonnull stop) {
    [parameters setValue:queryItem.value forKey:queryItem.name];
  }];
  return [parameters copy];
}

- (void)setParameters:(NSDictionary *)parameters {
  if (!parameters || parameters.count < 1) {
    return;
  }
  
  NSMutableArray *mutableQueryItems = [NSMutableArray array];
  [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:NSString.class]) {
      [mutableQueryItems addObject:[NSURLQueryItem queryItemWithName:key value:obj]];
    } else if ([obj isKindOfClass:NSNumber.class]) {
      
    }else {
      [NSException raise:@"Invalid parameter type." format:@"parameter type must be NSString."];
    }
  }];
  self.components.queryItems = [mutableQueryItems copy];
}

- (NSString *)debugDescription {
  return [self.components debugDescription];
}

- (NSString *)description {
  return [self.components description];
}

@end
