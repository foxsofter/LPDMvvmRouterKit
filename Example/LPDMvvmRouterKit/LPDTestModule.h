//
//  LPDTestModule.h
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/23.
//  Copyright © 2017年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>

@interface LPDTestModule : NSObject<LPDModuleProtocol>

-(void)test:(id<LPDEventProtocol>)event;

@end
