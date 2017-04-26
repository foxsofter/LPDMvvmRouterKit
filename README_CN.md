# LPDMvvmRouterKit

[![CI Status](http://img.shields.io/travis/foxsofter/LPDMvvmRouterKit.svg?style=flat)](https://travis-ci.org/foxsofter/LPDMvvmRouterKit)
[![Version](https://img.shields.io/cocoapods/v/LPDMvvmRouterKit.svg?style=flat)](http://cocoapods.org/pods/LPDMvvmRouterKit)
[![License](https://img.shields.io/cocoapods/l/LPDMvvmRouterKit.svg?style=flat)](http://cocoapods.org/pods/LPDMvvmRouterKit)
[![Platform](https://img.shields.io/cocoapods/p/LPDMvvmRouterKit.svg?style=flat)](http://cocoapods.org/pods/LPDMvvmRouterKit)

LPDMvvmRouterKit 是一个用 Objectivec-C 编写的，可用在 MVVM 框架下做路由。

- app 外部跳转页面
- app 内部页面跳转
- 消息总线


> [English Introduction](https://github.com/LPD-iOS/LPDMvvmRouterKit/blob/master/README.md)

## 示例

1. 利用 `git clone` 命令下载本仓库, `Examples` 目录包含了所有的示例程序；
2. 用 XCode 打开对应项目编译即可。

或执行以下命令：

```bash

git clone git@github.com:LPD-iOS/LPDMvvmRouterKit.git; 
cd LPDMvvmRouterKit/Examples; 
open 'LPDMvvmRouterKit.xcworkspace'

```

## 环境

- XCode 7.0+
- Swift 2.0+
- iOS 8.0+ / macOS 10.11+ / tvOS 8.0+

## 安装

### CocoaPods

LPDMvvmRouterKit 可以通过 [CocoaPods](http://cocoapods.org) 进行获取。只需要在你的 Podfile 中添加如下代码就能实现引入：

```ruby
pod "LPDMvvmRouterKit"
```

然后，执行如下命令即可：

```bash
$ pod install
```
## 快速使用

#### 1. 导入 LPDMvvmRouterKit

在你需要使用 LPDMvvmRouterKit 的地方添加如下代码引入 LPDMvvmRouterKit 模块：

```objective-c
#import <LPDMvvmKit/LPDMvvmKit.h>
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>
#import <LPDAdditionsKit/LPDAdditionsKit.h>

```

并且让 viewController 继承自 LPDViewController。


#### 2. 创建 viewModel

创建一个 viewModel。在viewModel的代码中添加以下的头文件：

```objective-c
#import <LPDMvvmKit/LPDMvvmKit.h>
#import <LPDMvvmRouterKit/LPDMvvmRouterKit.h>

```

#### 3. app 外部跳转页面

外部通过传入 URL，如果符合规则，即可跳转到app内部的对应的页面。

```objectivec

  NSURL *url = [NSURL URLWithString:@"me.ele.lpd://lpd/some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"];
  [[LPDMvvmRouter sharedInstance] openURL:url options:nil];

```


#### 4. app 内部路由的页面跳转

在 MVVM 框架下，我们只允许 viewModel 的跳转，所以页面的跳转只有 pushViewModel 和 presentViewModel 两种方式。

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

#### 5. 路由的消息总线

在 LPDMvvmRouterKit 库中有一个 LPDEvent 类，这个类是用来做消息总线用的。

```objectivec

  LPDEvent *event = [LPDEvent eventWithEventSelector:@"test:"];
  [[LPDModuleMediator sharedInstance] sendEvent:event];

```

在对应的 viewModel 中实现了对应的 test: 方法，即可在方法实现中获取到这条通知信息。方法后面的参数必须是 `id<LPDEventProtocol> `类型的。


## 使用指南

### 1. app 外部跳转页面

```objectivec

  NSURL *url = [NSURL URLWithString:@"me.ele.lpd://lpd/some/push?title=Some&x=11111.11&count=3&str=fwljfwljfwl"];
  [[LPDMvvmRouter sharedInstance] openURL:url options:nil];


```

通过传递一个 URL 字符串，能从 APP 外部跳转到 APP 内部的对应的页面。

URL 字符串的规则：

App scheme://modular scheme/viewModelName/push(present)?

路由会先验证 App scheme 能否配对，如果能，再验证 modular scheme 能否配对，如果能，找到对应的 viewModel,进行 push 或者present。

#### 参数说明

viewModelName 这个是 ViewModel 去掉前缀 LPD ，去掉后缀 viewModel 剩下的名字。比如一个 viewModel 的名字叫 LPDSomeViewModel，那么这里 viewModelName 就是 some。


options 的类型是 NSDictionary<UIApplicationOpenURLOptionsKey,id>

### 2. app 内部路由的页面跳转


app 内部的路由跳转的 URL 就不需要增加 App scheme 的前缀了，直接从 modular scheme 开始，后面的规则和上述所说的一样。

在 app 内部的页面进行页面跳转的时候，所有的页面跳转都是通过 navigationViewModel 实现的。具体实现会先拿到当前最顶层的 topNavigationController 的 viewModel，然后调用相应的页面跳转方法实现 app 内部路由的页面跳转。

支持的跳转方式有以下6种：


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

如果是 popViewModel，实现原理就是在 viewModel 中调用自己的 navigation 进行 popViewModelAnimated 操作。

```objectivec

[self.navigation popViewModelAnimated:YES];

```




* **popToRootViewModel**:


```objectivec

  [self.viewModel performSelector:@selector(popToRootViewModel)];


```

如果是 popToRootViewModel，实现原理就是在 viewModel 中调用自己的 navigation 进行 pop 操作。


```objectivec


[self.navigation popToRootViewModelAnimated:YES];

```

popToRootViewModel 会遍历整个 ViewModel 的栈，找到 rootViewModel 进行 pop。

* **presentViewModel**:

```objectivec

  [[LPDMvvmRouter sharedInstance] performActionWithUrl:[LPDRouteURL routerURLWithString:@"lpd://some/present?title=PresentSome&x=11111.11&count=3&str=fwljfwljfwl"] completion:^(id  _Nullable x) {
    
  }];

```

present 和 push 的原理一样，这里不再赘述。

* **dismissViewModel**:


```objectivec

  [self.viewModel performSelector:@selector(dismissViewModel)];

```

如果是 dismissViewModel，实现原理就是在 viewModel 中调用自己的 navigation 进行 dismissNavigationViewModelAnimated 操作。

```objectivec

[self.navigation dismissNavigationViewModelAnimated:YES completion:nil;

```



### 3. 路由的消息总线

LPDEvent 的设计之初是为了替代 app 内的消息通知的，专门用来做消息总线的。并不是用来callback的，也不是用来做函数调用的。

如果一个模块不关心某个事件，那么它就无须实现对应的方法。

为了接收到从消息总线上的消息，那么在实现方法的时候，需要接收一个 (id<LPDEventProtocol>)event 的参数。这个 event 里面包含了消息传递过来的所有参数字典，方法名，以及方法是同步方法和异步方法的信息。


#### 参数说明


eventSelector: 事件方法对应的字符串。
eventArgs: 事件传递的参数字典。
async: 这是一个 BOOL 类型标识的是 event 的方法是同步还是异步的方法。

## 备注

若有任何问题，期待得到您的反馈，`Issue` 和 `Pull request` 都是受欢迎的。

备注的备注：好用的话可以给个`星星`

## 作者

foxsofter, foxsofter@gmail.com

## 协议

LPDMvvmRouterKit 基于 MIT 协议进行分发和使用，更多信息参见协议文件。
