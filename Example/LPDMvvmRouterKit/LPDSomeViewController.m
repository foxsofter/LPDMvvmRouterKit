//
//  LPDSomeViewController.m
//  LPDModularKit
//
//  Created by foxsofter on 16/11/29.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import "LPDSomeViewController.h"
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>
#import <LPDAdditionsKit/LPDAdditionsKit.h>
#import "LPDSomeViewModel.h"

@interface LPDSomeViewController ()

@end

@implementation LPDSomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pushViewModel:(id)sender {
  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    NSString *ss = x;
  }];
  NSLog(@"x = %f", [self.viewModel x]);

}
- (IBAction)popViewModel:(id)sender {
    [self.viewModel performSelector:@selector(popViewModel)];
}

- (IBAction)popToRootViewModel:(id)sender {
    [self.viewModel performSelector:@selector(popToRootViewModel)];
}

- (IBAction)presentViewModel:(id)sender {
  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/present?title=PresentSome&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    NSString *ss = x;
  }];
}

- (IBAction)dismissViewModel:(id)sender {
    [self.viewModel performSelector:@selector(dismissViewModel)];
}

- (IBAction)openUrl:(id)sender {
  NSURL *url = [NSURL URLWithString:@"me.ele.lpd://lpd/some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"];
  [[LPDMvvmRouter sharedInstance] openURL:url options:nil];
}

- (IBAction)testEvent:(id)sender {
  LPDEvent *event = [LPDEvent eventWithEventSelector:@"test:"];
  [[LPDModuleMediator sharedInstance] sendEvent:event];
}

@end
