# NetWorkManager
网络请求
## YTKNetwork 基本组成

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

```objectivec
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
