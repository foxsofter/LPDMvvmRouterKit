//
//  LPDEvent.h
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/9.
//
//

#import <Foundation/Foundation.h>
#import "LPDEventProtocol.h"

@interface LPDEvent : NSObject<LPDEventProtocol>

+ (instancetype)eventWithEventSelector:(NSString *)eventSelector;

- (instancetype)initWithEventSelector:(NSString *)eventSelector;

@end
