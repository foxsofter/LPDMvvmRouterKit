//
//  LPDEventProtocol.h
//  Pods
//
//  Created by foxsofter on 17/3/9.
//
//

#import <Foundation/Foundation.h>

@protocol LPDEventProtocol <NSObject>

@property (nonatomic, copy, readonly) NSString *eventSelector;

@property (nonatomic, copy) NSDictionary *eventArgs;

@property (assign) BOOL async;

@end
