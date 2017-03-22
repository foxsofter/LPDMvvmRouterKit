//
//  LPDRuntime.hpp
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/9.
//
//

#ifndef LPDRuntime_hpp
#define LPDRuntime_hpp

#import <Foundation/Foundation.h>
#import <objc/objc.h>

typedef BOOL(^PredicateBlock)(Class cls);

NSArray<Class> *getClassesMatching(PredicateBlock predicate);

#endif /* LPDRuntime_hpp */
