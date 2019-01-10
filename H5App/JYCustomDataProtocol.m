//
//  JYCustomDataProtocol.m
//  JYNSURLProtocolDemo
//
//  Created by James Yu on 15/8/25.
//  Copyright (c) 2015年 James. All rights reserved.
//

#import "JYCustomDataProtocol.h"
#import "JSDownManager.h"

static NSString * const hasInitKey = @"JYCustomDataProtocolKey";

@interface JYCustomDataProtocol ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation JYCustomDataProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([request.URL.absoluteString containsString:@".js"] || [request.URL.absoluteString containsString:@".css"]) {
        if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //这边可用干你想干的事情。。更改地址，或者设置里面的请求头。。
    return mutableReqeust;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //做下标记，防止递归调用
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
    
    //这边就随便你玩了。。可以直接返回本地的模拟数据，进行测试
    typeof(self) weakSelf = self;
    [[JSDownManager new] downloadFileWithURL:self.request.URL.absoluteString downLoadBlock:^(BOOL cache,NSString *path) {
        typeof(weakSelf)strongSelf = weakSelf;
        if (cache) {
//            NSString *str = @"测试数据";
//
//            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"path===> %@",path);
            CFStringRef pathExtension = (__bridge_retained CFStringRef)[path pathExtension];
            CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
            CFRelease(pathExtension);
            
            //The UTI can be converted to a mime type:
            NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
            if (type != NULL)
                CFRelease(type);
            
            //加载本地资源
            NSData *data = [NSData dataWithContentsOfFile:path];
            [self sendResponseWithData:data mimeType:mimeType];
            
        } else {
            strongSelf.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:strongSelf];
        }
    }];
    
//    BOOL enableDebug = NO;
//
//    if (enableDebug) {
//
//        NSString *str = @"测试数据";
//
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//
//        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
//                                                            MIMEType:@"text/plain"
//                                               expectedContentLength:data.length
//                                                    textEncodingName:nil];
//        [self.client URLProtocol:self
//              didReceiveResponse:response
//              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//
//        [self.client URLProtocol:self didLoadData:data];
//        [self.client URLProtocolDidFinishLoading:self];
//    }
//    else {
//        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
//    }
}


- (void)sendResponseWithData:(NSData *)data mimeType:(nullable NSString *)mimeType
{
    NSLog(@"sendResponseWithData start");
    // 这里需要用到MIMEType
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:super.request.URL
                                                        MIMEType:mimeType
                                           expectedContentLength:data.length
                                                textEncodingName:nil];
    
    if ([self client]) {
        if ([self.client respondsToSelector:@selector(URLProtocol:didReceiveResponse:cacheStoragePolicy:)]) {
            [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        }
        if ([self.client respondsToSelector:@selector(URLProtocol:didLoadData:)]) {
            [[self client] URLProtocol:self didLoadData:data];
        }
        if ([self.client respondsToSelector:@selector(URLProtocolDidFinishLoading:)]) {
            [[self client] URLProtocolDidFinishLoading:self];
        }
    }
    
    NSLog(@"sendResponseWithData end");
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

@end
