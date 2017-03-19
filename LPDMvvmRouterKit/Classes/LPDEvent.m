//
//  LPDEvent.m
//  LPDModuleKit
//
//  Created by foxsofter on 17/3/9.
//
//

#import "LPDEvent.h"

@implementation LPDEvent

@synthesize eventSelector = _eventSelector;
@synthesize eventArgs = _eventArgs;
@synthesize async = _async;

+ (instancetype)eventWithEventSelector:(NSString *)eventSelector {
  return [[self alloc] initWithEventSelector:eventSelector];
}

- (instancetype)initWithEventSelector:(NSString *)eventSelector {
  self = [super init];
  if (self) {
    _eventSelector = eventSelector;
  }
  return self;
}

@end
