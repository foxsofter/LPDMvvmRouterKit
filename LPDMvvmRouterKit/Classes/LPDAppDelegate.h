//
//  LPDAppDelegate.h
//  Pods
//
//  Created by foxsofter on 17/3/8.
//
//

#import <Foundation/Foundation.h>

@interface LPDOpenURLItem : NSObject

@property (nonatomic, strong) NSURL *openURL;
@property (nonatomic, strong) NSString *sourceApplication;
@property (nonatomic, strong) NSDictionary *options;

@end

@interface LPDxAppDelegate : NSObject

@end
