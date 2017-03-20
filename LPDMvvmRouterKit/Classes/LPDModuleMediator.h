//
//  LPDModuleMediator.h
//  Pods
//
//  Created by foxsofter on 17/3/19.
//
//

#import <Foundation/Foundation.h>
#import "LPDEventProtocol.h"
#import "LPDConstant.h"

@interface LPDModuleMediator : NSObject

+ (instancetype)sharedInstance;

- (void)sendEvent:(id<LPDEventProtocol>)event;

@end
