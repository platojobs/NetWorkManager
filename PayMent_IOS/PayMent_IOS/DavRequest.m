//
//  DavRequest.m
//  PayMent_IOS
//
//  Created by 崔曦 on 2018/11/30.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import "DavRequest.h"

@implementation DavRequest

//父类方法的
- (NSString *)requestUrl {
    return @"/ico-funding-web/user/login";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
//以及填写请求参数requestArgument方法

- (id)requestArgument {
    return @{
             @"ip": @"192.168.2.5",
             @"mobile": @"167089701568",
             @"password": @"123"
             };
}

@end
