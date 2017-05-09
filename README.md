# LPDMvvmRouterKit


<p align="center">    

<a href="https://travis-ci.org/LPD-iOS/LPDMvvmRouterKit"><img src="http://img.shields.io/travis/LPD-iOS/LPDMvvmRouterKit.svg?style=flat"></a>

<a href="https://codecov.io/gh/LPD-iOS/LPDMvvmRouterKit"><img src="https://codecov.io/gh/LPD-iOS/LPDMvvmRouterKit/branch/master/graph/badge.svg"></a>

<a href="https://www.codacy.com/app/halfrost/LPDMvvmRouterKit?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=LPD-iOS/LPDMvvmRouterKit&amp;utm_campaign=Badge_Grade"><img src="https://api.codacy.com/project/badge/Grade/cee4a702ca2842cda059558c6a020a8d"/></a>

<img src="https://img.shields.io/cocoapods/dt/LPDMvvmRouterKit.svg">

<img src="https://img.shields.io/cocoapods/at/LPDMvvmRouterKit.svg">

<img src="https://img.shields.io/cocoapods/metrics/doc-percent/LPDMvvmRouterKit.svg">

<img src="https://img.shields.io/badge/platform-iOS%20%7C%20OSX%20%7C%20tvOS%20%7C%20watchOS-ff69b4.svg">

<img src="https://img.shields.io/badge/language-Objective--C-orange.svg">

<a href=""><img src="https://img.shields.io/badge/license-MIT-000000.svg"></a>

<img src="https://img.shields.io/badge/made%20with-%3C3-blue.svg">

<a href="https://codebeat.co/projects/github-com-lpd-ios-lpdmvvmkit-master"><img alt="codebeat badge" src="https://codebeat.co/badges/17255a58-8abc-4f16-85ee-a7dbe125b215" /></a>

<a href="http://cocoapods.org/pods/LPDMvvmRouterKit"><img alt="codebeat badge" src="https://img.shields.io/cocoapods/v/LPDMvvmRouterKit.svg?style=flat" /></a>

<a href="https://lpd-ios.github.io/"><img src="https://img.shields.io/badge/Blog-LPD--iOS-red.svg?style=flat"></a>

<a href="https://github.com/LPD-iOS"><img src="https://img.shields.io/badge/Organizations-LPD--iOS-brightgreen.svg?style=flat&colorA=abcdef"></a>

<img src="https://img.shields.io/chrome-web-store/stars/nimelepbpejjlbmoobocpfnjhihnpked.svg?colorA=a0cd34">


</p>   

LPDMvvmRouterKit is written in a Objectivec-C, available under the MVVM framework.


- app external page transition
- app internal page transition
- message bus

> [Chinese Introduction](https://github.com/LPD-iOS/LPDMvvmRouterKit/blob/master/README_CN.md)


## Example

1. Use the `git clone` command to download the repository, the` Examples` directory contains all the sample programs;
2. Use XCode to open the corresponding project, run the example project.

Or execute the following command:

```bash

git clone git@github.com:LPD-iOS/LPDMvvmRouterKit.git; 
cd LPDMvvmRouterKit/Examples; 
open 'LPDMvvmRouterKit.xcworkspace'

```

## Requirements


- XCode 7.0+
- Swift 2.0+
- iOS 8.0+ / macOS 10.11+ / tvOS 8.0+


## Installation

LPDMvvmRouterKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LPDMvvmRouterKit"

```  

Then, execute the following command:

```bash
$ pod install
```


## Quick to use


### 1. Import LPDMvvmRouterKit

Add the following code to the LPDMvvmRouterKit module where you need to use LPDMvvmRouterKit:

```objective-c
#import <LPDMvvmKit/LPDMvvmKit.h>
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>
#import <LPDAdditionsKit/LPDAdditionsKit.h>

```

And let the viewController inherit from the LPDViewController.

### 2. Create viewModel

Create a viewModel. Add the following header file to the code in viewModel:

```objective-c
#import <LPDMvvmKit/LPDMvvmKit.h>
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>

```

### 3. App external page transition

External through the incoming URL, if the rules, you can transition to the corresponding page within the app.

```objectivec

  NSURL *url = [NSURL URLWithString:@"me.ele.lpd://lpd/some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"];
  [[LPDMvvmRouter sharedInstance] openURL:url options:nil];

```

### 4. App internal page transition


In the MVVM framework, we only allow viewModel transition, so the page transition would only pushViewModel and presentViewModel two ways.

pushViewModel:

```objectivec

  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {

  }];

```

popViewModel:

```objectivec

  [self.viewModel performSelector:@selector(popViewModel)];


```

popToRootViewModel:


```objectivec

  [self.viewModel performSelector:@selector(popToRootViewModel)];


```



presentViewModel:

```objectivec

  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/present?title=PresentSome&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    
  }];

```


dismissViewModel:


```objectivec

  [self.viewModel performSelector:@selector(dismissViewModel)];

```

### 5. Router message bus

In the LPDMvvmRouterKit library there is a LPDEvent class, this class is used to do the message bus.

```objectivec

  LPDEvent *event = [LPDEvent eventWithEventSelector:@"test:"];
  [[LPDModuleMediator sharedInstance] sendEvent:event];

```

In the corresponding viewModel to implement
 the corresponding test: method, you can get in the method to receive this notification information. The arguments following the method must be the type of `id <LPDEventProtocol>`.


## Guidebook

### 1. App external page transition

```objectivec

  NSURL *url = [NSURL URLWithString:@"me.ele.lpd://lpd/some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"];
  [[LPDMvvmRouter sharedInstance] openURL:url options:nil];


```

By passing a URL string, you can transition from outside APP to the corresponding page inside the APP.


URL string rules:

App scheme://modular scheme/viewModelName/push(present)?

The route will first verify the App scheme can be paired, if it can, and then verify the modular scheme can match, if you can find the corresponding viewModel, push or present.

#### Parameter Description

ViewModelName this is the viewModel remove the prefix LPD, remove the suffix viewModel the remaining name. Such as a viewModel called LPDSomeViewModel, then here viewModelName is some.

the type of options is NSDictionary<UIApplicationOpenURLOptionsKey,id>


### 2. App internal page transition


App internal routing transition URL does not need to increase the App scheme prefix, and directly from the modular scheme, followed by the rules and the above said the same.

In the page inside the app page jump, all the page transition is achieved through the navigationViewModel. The specific implementation will get the top of the top top of the topNavigationController viewModel, and then call the corresponding page transition method to achieve the internal routing page page transition.

There are six ways to support the transition:

```objectivec

push
pop
popto
poptoroot
present
dismiss

```

* **pushViewModel**:

```objectivec

  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {

  }];

```


* **popViewModel**:

```objectivec

  [self.viewModel performSelector:@selector(popViewModel)];


```


If it is popViewModel, the implementation of the principle is in the viewModel call their own navigation popViewModelAnimated operation.


```objectivec

[self.navigation popViewModelAnimated:YES];

```


* **popToRootViewModel**:


```objectivec

  [self.viewModel performSelector:@selector(popToRootViewModel)];


```

If it is popToRootViewModel, the implementation of the principle is in the viewModel call their own navigation for pop operation.


```objectivec


[self.navigation popToRootViewModelAnimated:YES];

```

PopToRootViewModel will traverse the entire ViewModel stack and find rootViewModel for pop.



* **presentViewModel**:

```objectivec

  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/present?title=PresentSome&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    
  }];

```


Present and push the same principle, do not repeat here.


* **dismissViewModel**:


```objectivec

  [self.viewModel performSelector:@selector(dismissViewModel)];

```


If it is a dismissViewModel, the implementation principle is to call your navigation in the viewModel for the dismissNavigationViewModelAnimated operation.


```objectivec

[self.navigation dismissNavigationViewModelAnimated:YES completion:nil;

```

### 3. Router message bus


LPDEvent was designed to replace the message within the app notice, specifically used to do the message bus. Not used to callback, nor is it used to do the function call.

If a module does not care about an event, then it does not need to implement the corresponding method.

In order to receive a message from the message bus, then in the implementation of the method, you need to receive a (id <LPDEventProtocol>) event parameters. This event contains all the parameters of the message over the dictionary, method name, and methods are synchronized and asynchronous method of information.



#### Parameter Description

EventSelector: The string corresponding to the event method.
EventArgs: event passed by the parameter dictionary.
Async: This is a BOOL type that identifies whether the method of the event is synchronous or asynchronous.

## Remarks

If you have any questions, expect your feedback.


Note: if easy to use, please give me a `star``

## Author

foxsofter, foxsofter@gmail.com

## License

LPDMvvmRouterKit is available under the MIT license. See the LICENSE file for more info.

