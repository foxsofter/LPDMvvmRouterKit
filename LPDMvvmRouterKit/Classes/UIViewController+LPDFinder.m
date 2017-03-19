//
//  UIViewController+LPDFinder.m
//  LPDMvvmRouterKit
//
//  Created by foxsofter on 16/11/28.
//  Copyright © 2016年 foxsofter. All rights reserved.
//

#import "UIViewController+LPDFinder.h"

@implementation UIViewController (LPDFinder)

- (UIViewController *)getTopViewController {
  if (self.presentedViewController) {
    return [self.presentedViewController getTopViewController];
  } else if ([self isKindOfClass:UINavigationController.class]) {
    return [[(UINavigationController *)self visibleViewController] getTopViewController];
  }
  return self;
}

- (UINavigationController *)getTopNavigationController {
  UIViewController *topViewController = [self getTopViewController];
  UINavigationController *topNavigationController = findByViewController(topViewController);
  if (topNavigationController) {
    return topNavigationController;
  }
  topNavigationController = findByResponder(topViewController);
  if (topNavigationController) {
    return topNavigationController;
  }
  return findByChildViewController(topViewController);
}

UINavigationController *findByViewController(UIViewController *topViewController) {
  if (topViewController.navigationController) {
    return topViewController.navigationController;
  } else if (topViewController.presentingViewController) {
    return findByViewController(topViewController.presentingViewController);
  }
  return nil;
}

UINavigationController *findByResponder(UIViewController *topViewController) {
  UIResponder *nextResponder = topViewController.nextResponder;
  while (YES) {
    if (!nextResponder) {
      return nil;
    }
    if ([nextResponder isKindOfClass:UINavigationController.class]) {
      return (UINavigationController*)nextResponder;
    }
    nextResponder = [nextResponder nextResponder];
  }
}

UINavigationController *findByChildViewController(UIViewController*topViewController) {
  NSArray *childViewControllers = topViewController.childViewControllers;
  for (UIViewController *childViewController in childViewControllers) {
    if ([childViewController isKindOfClass:UINavigationController.class]) {
      return childViewController;
    }
    UINavigationController *navigationController = findByChildViewController(childViewController);
    if (navigationController) {
      return navigationController;
    }
  }
  return nil;
}


@end
