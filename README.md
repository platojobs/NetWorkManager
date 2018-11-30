# NetWorkManager

网络请求

## 基本用法

网络请求
### YTKNetwork 基本组成

YTKNetwork 包括以下几个基本的类：

 * YTKNetworkConfig 类：用于统一设置网络请求的服务器和 CDN 的地址。
 * YTKRequest 类：所有的网络请求类需要继承于 `YTKRequest` 类，每一个 `YTKRequest` 类的子类代表一种专门的网络请求。

接下来我们详细地来解释这些类以及它们的用法。

### YTKNetworkConfig 类

YTKNetworkConfig 类有两个作用：

 1. 统一设置网络请求的服务器和 CDN 的地址。
 2. 管理网络请求的 YTKUrlFilterProtocol 实例（在[高级功能教程](ProGuide_cn.md) 中有介绍）。

我们为什么需要统一设置服务器地址呢？因为：

 1. 按照设计模式里的 `Do Not Repeat Yourself` 原则，我们应该把服务器地址统一写在一个地方。
 2. 在实际业务中，我们的测试人员需要切换不同的服务器地址来测试。统一设置服务器地址到 YTKNetworkConfig 类中，也便于我们统一切换服务器地址。
 
具体的用法是，在程序刚启动的回调中，设置好 YTKNetworkConfig 的信息，如下所示：

```objc
- (BOOL)application:(UIApplication *)application 
   didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
   config.baseUrl = @"http://baidu.com";
   config.cdnUrl = @"http://btc.bi";
}
```

设置好之后，所有的网络请求都会默认使用 YTKNetworkConfig 中 `baseUrl` 参数指定的地址。

大部分企业应用都需要对一些静态资源（例如图片、js、css）使用 CDN。YTKNetworkConfig 的 `cdnUrl` 参数用于统一设置这一部分网络请求的地址。

当我们需要切换服务器地址时，只需要修改 YTKNetworkConfig 中的 `baseUrl` 和 `cdnUrl` 参数即可。

+ ## 调用请求，block和delegate两种方式
+ ## 验证服务器返回内容
+ ## 使用 CDN 地址
+ ## 断点续传
+ ## 按时间缓存内容

--------

## 进阶用法

### `YTKUrlFilterProtocol 接口`

```objc
// YTKUrlArgumentsFilter.h
// 实现自己的 URL 拼接工具类
@interface YTKUrlArgumentsFilter : NSObject <YTKUrlFilterProtocol>

+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end


// YTKUrlArgumentsFilter.m
@implementation YTKUrlArgumentsFilter {
    NSDictionary *_arguments;
}

+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return [YTKUrlArgumentsFilter urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}

@end
```

使用以上这个类可以实现为接口新增统一的参数
```objc
- (BOOL)application:(UIApplication *)application 
         didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupRequestFilters];
    return YES;
}

- (void)setupRequestFilters {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
    [config addUrlFilter:urlFilter];
}
```

### YTKBatchRequest 类

> `YTKBatchRequest` 类：用于方便地发送批量的网络请求，`YTKBatchRequest` 是一个容器类，它可以放置多个 `YTKRequest` 子类，并统一处理这多个网络请求的成功和失败。

```objc
#import "YTKBatchRequest.h"
#import "GetImageApi.h"
#import "GetUserInfoApi.h"

- (void)sendBatchRequest {
    GetImageApi *task1 = [[GetImageApi alloc] initWithImageId:@"刘德华.jpg"];
    GetImageApi *task2 = [[GetImageApi alloc] initWithImageId:@"郭富城.jpg"];
    GetImageApi *task3 = [[GetImageApi alloc] initWithImageId:@"张学友.jpg"];
    GetUserInfoApi *task4 = [[GetUserInfoApi alloc] initWithUserId:@"LIMING"];
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[task1, task2, task3, task4]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSLog(@"succeed");
        NSArray *requests = batchRequest.requestArray;
        GetImageApi *task1 = (GetImageApi *)requests[0];
        GetImageApi *task2 = (GetImageApi *)requests[1];
        GetImageApi *task3 = (GetImageApi *)requests[2];
        GetUserInfoApi *user = (GetUserInfoApi *)requests[3];
        // deal with requests result ...
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
    }];
}
```

