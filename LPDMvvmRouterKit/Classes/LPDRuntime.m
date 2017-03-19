//
//  LPDRuntime.cpp
//  Pods
//
//  Created by foxsofter on 17/3/9.
//
//

#include "LPDRuntime.h"
#import <objc/runtime.h>

inline NSArray<Class> *getClassesMatching(PredicateBlock predicate) {
  NSMutableArray *array = [NSMutableArray array];
  
  Class * classes = NULL;
  int numClasses = objc_getClassList(NULL, 0);
  
  if (numClasses > 0 ) {
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    Class cls = nil;
    for (int i = 0; i < numClasses; i++) {
      cls = classes[i];
      if (predicate(cls)) {
        [array addObject:cls];
      }
    }
    free(classes);
  }
  return array;
}
