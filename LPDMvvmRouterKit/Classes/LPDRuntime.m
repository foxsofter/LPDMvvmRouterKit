//
//  LPDRuntime.cpp
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/9.
//
//

#include "LPDRuntime.h"
#import <objc/runtime.h>

inline NSArray<Class> *getClassesMatching(PredicateBlock predicate) {
  NSMutableArray *array = [NSMutableArray array];
  
  int count;
  Class cls;
  Class * classes = objc_copyClassList(&count);
  for (int i = 0; i < count; i++) {
    cls = classes[i];
    if (predicate(cls)) {
      [array addObject:cls];
    }
  }
  free(classes);
  return array;
}
