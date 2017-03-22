//
//  NSObject+LPDPerformAction.m
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 17/3/13.
//
//

#import "NSObject+LPDPerformAction.h"
#import <objc/runtime.h>

static const char *cNumberTypes = "islqISLQfdbB";
static inline BOOL isCharArrayContains(const char *c, const char *cArray);
static inline void getTypeValueByNSString(NSString *inString, const char *typeCode, void(^resultBlock)(void *));
static inline void getTypeValueByNSValue(NSValue *inValue, const char *typeCode, void(^resultBlock)(void *));

@implementation NSObject (LPDPerformAction)

- (BOOL)performAction:(NSString *)actionName
           parameters:(nullable NSDictionary *)parameters
           completion:(void (^ __nullable)(__nullable id))completion {
  
  SEL selector = NSSelectorFromString(actionName);
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    if (sig.numberOfArguments - 2 > parameters.count) {
      [NSException raise:@"parameters does not matching." format:@"parameters does not matching."];
    }
    
    NSArray *components = [actionName componentsSeparatedByString:@":"];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.selector = selector;
    invocation.target = self;
    [invocation retainArguments];
    for (NSInteger i = 0; i < components.count - 1; i++) {
      id parameterValue = parameters[components[i]];
      const char *parameterType = [sig getArgumentTypeAtIndex:i + 2];
      if ([parameterValue isKindOfClass:NSString.class]) {
        getTypeValueByNSString(parameterValue, parameterType, ^(void *value) {
          [invocation setArgument:value atIndex:i + 2];
        });
      } else if ([parameterValue isKindOfClass:NSValue.class]) {
        getTypeValueByNSValue(parameterValue, parameterType, ^(void *value) {
          [invocation setArgument:value atIndex:i + 2];
        });
      } else {
        [invocation setArgument:&parameterValue atIndex:i + 2];
      }
    }
    [invocation invoke];
    
    if (completion) {
      const char *returnType = sig.methodReturnType;
      id result;
      if(!strcmp(returnType, @encode(void))){
        result =  nil;
      } else if (!strcmp(returnType, @encode(id))){
        void *buffer;
        [invocation getReturnValue:&buffer];
        result = (__bridge id)(buffer);
      } else {
        NSUInteger length = [sig methodReturnLength];
        void *buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        if (!strcmp(returnType, @encode(char))) {
          result = [NSNumber numberWithChar:*((char*)buffer)];
        } else if (!strcmp(returnType, @encode(int))) {
          result = [NSNumber numberWithInt:*((int*)buffer)];
        } else if (!strcmp(returnType, @encode(short))) {
          result = [NSNumber numberWithShort:*((short*)buffer)];
        } else if (!strcmp(returnType, @encode(long))) {
          result = [NSNumber numberWithLong:*((long*)buffer)];
        } else if (!strcmp(returnType, @encode(long long))) {
          result = [NSNumber numberWithLongLong:*((long long*)buffer)];
        } else if (!strcmp(returnType, @encode(unsigned char))) {
          result = [NSNumber numberWithUnsignedChar:*((unsigned char*)buffer)];
        } else if (!strcmp(returnType, @encode(unsigned int))) {
          result = [NSNumber numberWithUnsignedInt:*((unsigned int*)buffer)];
        } else if (!strcmp(returnType, @encode(unsigned short))) {
          result = [NSNumber numberWithUnsignedShort:*((unsigned short*)buffer)];
        } else if (!strcmp(returnType, @encode(unsigned long))) {
          result = [NSNumber numberWithUnsignedLong:*((unsigned long*)buffer)];
        } else if (!strcmp(returnType, @encode(unsigned long long))) {
          result = [NSNumber numberWithUnsignedLongLong:*((unsigned long long*)buffer)];
        } else if (!strcmp(returnType, @encode(float))) {
          result = [NSNumber numberWithFloat:*((float*)buffer)];
        } else if (!strcmp(returnType, @encode(double))) {
          result = [NSNumber numberWithDouble:*((double*)buffer)];
        } else if (!strcmp(returnType, @encode(BOOL))) {
          result = [NSNumber numberWithBool:*((BOOL*)buffer)];
        } else if (!strcmp(returnType, @encode(NSInteger))) {
          result = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        } else if (!strcmp(returnType, @encode(NSUInteger))) {
          result = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        } else if (!strcmp(returnType, @encode(CGPoint))) {
          result = [NSValue valueWithCGPoint:*((CGPoint*)buffer)];
        } else if (!strcmp(returnType, @encode(CGVector))) {
          result = [NSValue valueWithCGVector:*((CGVector*)buffer)];
        } else if (!strcmp(returnType, @encode(CGSize))) {
          result = [NSValue valueWithCGSize:*((CGSize*)buffer)];
        } else if (!strcmp(returnType, @encode(CGRect))) {
          result = [NSValue valueWithCGRect:*((CGRect*)buffer)];
        } else if (!strcmp(returnType, @encode(CGAffineTransform))) {
          result = [NSValue valueWithCGAffineTransform:*((CGAffineTransform*)buffer)];
        } else if (!strcmp(returnType, @encode(UIEdgeInsets))) {
          result = [NSValue valueWithUIEdgeInsets:*((UIEdgeInsets*)buffer)];
        } else if (!strcmp(returnType, @encode(UIOffset))) {
          result = [NSValue valueWithUIOffset:*((UIOffset*)buffer)];
        }
      }
      completion(result);
    }
  }
}

- (void)setIvarValues:(NSDictionary<NSString *,id> *)parameters {
  unsigned int ivarCount = 0;
  Ivar *ivars = class_copyIvarList(self.class, &ivarCount);
  for (unsigned int i = 0; i < ivarCount; i++) {
    const char *ivarName = ivar_getName(ivars[i]);
    const char *ivarType = ivar_getTypeEncoding(ivars[i]);
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      NSString *varName = [NSString stringWithUTF8String:ivarName];
      if ([key isEqualToString:varName] || [key isEqualToString:[varName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]]]) {
        NSString *ivarValue = obj;
        if (!strcmp(ivarType, @encode(CGPoint))) {
          CGPoint value = CGPointFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithCGPoint:value]);
        } else if (!strcmp(ivarType, @encode(CGVector))) {
          CGVector value = CGVectorFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithCGVector:value]);
        } else if (!strcmp(ivarType, @encode(CGSize))) {
          CGSize value = CGSizeFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithCGSize:value]);
        } else if (!strcmp(ivarType, @encode(CGRect))) {
          CGRect value = CGRectFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithCGRect:value]);
        } else if (!strcmp(ivarType, @encode(CGAffineTransform))) {
          CGAffineTransform value = CGAffineTransformFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithCGAffineTransform:value]);
        } else if (!strcmp(ivarType, @encode(UIEdgeInsets))) {
          UIEdgeInsets value = UIEdgeInsetsFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithUIEdgeInsets:value]);
        } else if (!strcmp(ivarType, @encode(UIOffset))) {
          UIOffset value = UIOffsetFromString(ivarValue);
          object_setIvar(self, ivars[i], [NSValue valueWithUIOffset:value]);
        } else if (!strcmp(ivarType, @encode(char))) {
          object_setIvar(self, ivars[i], ivarValue);
        } else if ([[NSString stringWithUTF8String:ivarType] containsString:@"NSString"]) {
          object_setIvar(self, ivars[i], ivarValue);
        } else if (strlen(cNumberTypes) == 1 && isCharArrayContains(ivarType, cNumberTypes)) {
          NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
          NSNumber *numberValue = [formatter numberFromString:ivarValue];
          [self setValue:numberValue forKey:key];
        } else {
          object_setIvar(self, ivars[i], ivarValue);
        }
      }
    }];
    
  }
  free(ivars);
}

@end

static inline BOOL isCharArrayContains(const char *c, const char *cArray) {
  while (*cArray) {
    if (strchr(c, *cArray)) {
      return YES;
    }
    cArray++;
  }
  return NO;
}

static inline void getTypeValueByNSString(NSString *inString, const char *typeCode, void(^resultBlock)(void *)) {
  if (!strcmp(typeCode, @encode(CGPoint))) {
    CGPoint value = CGPointFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGVector))) {
    CGVector value = CGVectorFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGSize))) {
    CGSize value = CGSizeFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGRect))) {
    CGRect value = CGRectFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGAffineTransform))) {
    CGAffineTransform value = CGAffineTransformFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(UIEdgeInsets))) {
    UIEdgeInsets value = UIEdgeInsetsFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(UIOffset))) {
    UIOffset value = UIOffsetFromString(inString);
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(char)) || !strcmp(typeCode, @encode(unsigned char))) {
    resultBlock(&inString);
  } else if (strlen(typeCode) == 1 && isCharArrayContains(typeCode, cNumberTypes)) {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *numberValue = [formatter numberFromString:inString];
    if (!strcmp(typeCode, @encode(int))) {
      int value = [numberValue intValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(short))) {
      short value = [numberValue shortValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(long))) {
      long value = [numberValue longValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(long long))) {
      long long value = [numberValue longLongValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned char))) {
      unsigned char value = [numberValue unsignedCharValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned int))) {
      unsigned int value = [numberValue unsignedIntValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned short))) {
      unsigned short value = [numberValue unsignedShortValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned long))) {
      unsigned long value = [numberValue unsignedLongValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned long long))) {
      unsigned long long value = [numberValue unsignedLongLongValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(float))) {
      float value = [numberValue floatValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(double))) {
      double value = [numberValue doubleValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(BOOL))) {
      BOOL value = [numberValue boolValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(NSInteger))) {
      NSInteger value = [numberValue integerValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(NSUInteger))) {
      NSUInteger value = [numberValue unsignedIntegerValue];
      resultBlock(&value);
    }
  } else {
    resultBlock(&inString);
  }
}

static inline void getTypeValueByNSValue(NSValue *inValue, const char *typeCode, void(^resultBlock)(void *)) {
  if (!strcmp(typeCode, @encode(CGPoint))) {
    CGPoint value = [inValue CGPointValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGVector))) {
    CGVector value = [inValue CGVectorValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGSize))) {
    CGSize value = [inValue CGSizeValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGRect))) {
    CGRect value = [inValue CGRectValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(CGAffineTransform))) {
    CGAffineTransform value = [inValue CGAffineTransformValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(UIEdgeInsets))) {
    UIEdgeInsets value = [inValue UIEdgeInsetsValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(UIOffset))) {
    UIOffset value = [inValue UIOffsetValue];
    resultBlock(&value);
  } else if (!strcmp(typeCode, @encode(char)) || !strcmp(typeCode, @encode(unsigned char))) {
    char value = [(NSNumber*)inValue charValue];
    resultBlock(&value);
  } else if (strlen(typeCode) == 1 && isCharArrayContains(typeCode, cNumberTypes)) {
    NSNumber *numberValue = inValue;
    if (!strcmp(typeCode, @encode(int))) {
      int value = [numberValue intValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(short))) {
      short value = [numberValue shortValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(long))) {
      long value = [numberValue longValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(long long))) {
      long long value = [numberValue longLongValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned int))) {
      unsigned int value = [numberValue unsignedIntValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned short))) {
      unsigned short value = [numberValue unsignedShortValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned long))) {
      unsigned long value = [numberValue unsignedLongValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(unsigned long long))) {
      unsigned long long value = [numberValue unsignedLongLongValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(float))) {
      float value = [numberValue floatValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(double))) {
      double value = [numberValue doubleValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(BOOL))) {
      BOOL value = [numberValue boolValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(NSInteger))) {
      NSInteger value = [numberValue integerValue];
      resultBlock(&value);
    } else if (!strcmp(typeCode, @encode(NSUInteger))) {
      NSUInteger value = [numberValue unsignedIntegerValue];
      resultBlock(&value);
    }
  } else {
    resultBlock(&inValue);
  }
}
