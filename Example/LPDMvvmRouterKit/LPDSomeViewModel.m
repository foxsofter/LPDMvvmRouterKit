//
//  LPDSomeViewModel.m
//  LPDModularKit
//
//  Created by foxsofter on 16/11/29.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import "LPDSomeViewModel.h"

@implementation LPDSomeViewModel

- (void)popViewModel {
    [self.navigation popViewModelAnimated:YES];
}

- (void)popToRootViewModel {
    [self.navigation popToRootViewModelAnimated:YES];
}

- (void)dismissViewModel {
    [self.navigation dismissNavigationViewModelAnimated:YES
                                             completion:^{
                                                 
                                             }];
}

@end
