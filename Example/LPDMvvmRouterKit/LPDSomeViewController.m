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

@interface LPDSomeViewController ()

@end

@implementation LPDSomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushViewModel:(id)sender {
  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[NSURL URLWithString:@"lpd://some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    NSString *ss = x;
  }];
  NSLog(@"self.x:%f", [self.viewModel x]);

}

- (IBAction)presentViewModel:(id)sender {
  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[NSURL URLWithString:@"lpd://some/present?title=PresentSome&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    NSString *ss = x;
  }];
}


@end
