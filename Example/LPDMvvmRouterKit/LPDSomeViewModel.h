//
//  LPDSomeViewModel.h
//  LPDModularKit
//
//  Created by foxsofter on 16/11/29.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import <LPDMvvmKit/LPDMvvmKit.h>
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>

@interface LPDSomeViewModel : LPDViewModel

@property (nonatomic) NSInteger count;

@property (nonatomic, copy) NSString *str;

@property (nonatomic) CGFloat x;

@property (nonatomic) CGSize size;

- (void)popViewModel;
- (void)popToRootViewModel;
- (void)dismissViewModel;

@end
