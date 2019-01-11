//
//  JSDownManager.m
//  H5App
//
//  Created by Blavtes on 2019/1/10.
//  Copyright © 2019 Blavtes. All rights reserved.
//

#import "JSDownManager.h"
#import "NSString+MD5.h"

@interface JSDownManager()
@end

@implementation JSDownManager



//把url传给这个方法

- (void)downloadFileWithURL:(NSString *)urlStr downLoadBlock:(DownLoadBlock)block
{
    
  
    self.downLoadBlock = block;
    self.downLoadPath = [urlStr MD5Sum];
    self.downLoadEndPath = [urlStr pathExtension];
    //默认配置
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self cachePath]] == YES) {
        if (self.downLoadBlock) {
//            NSLog(@"js/css ~~~~~");
            self.downLoadBlock(YES,[self cachePath]);
        }
        return;
    }
    NSURLSessionConfiguration *configuration= [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //得到session对象
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // url
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //创建任务
    
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url];
    
    //开始任务
    
    [downloadTask resume];
    
}

- (NSString *)cachePath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"[self.downLoadPath pathExtension] %@",self.downLoadEndPath);
    NSString *js =  [cachePath stringByAppendingPathComponent:self.downLoadEndPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:js]) {
         [fileManager createDirectoryAtPath:js withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *savePath = [js stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",self.downLoadPath,self.downLoadEndPath]];
    return savePath;
}

#pragma mark -- NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
//    static char *queuname = "__wirtghe";
//    typeof(self)weakSelf = self;
//    dispatch_barrier_async(dispatch_queue_create(queuname, DISPATCH_QUEUE_CONCURRENT), ^{
         typeof(self)strongSelf = self;
        NSError *saveError;
        
        NSString *savePath = [strongSelf cachePath];
//        NSLog(@"js/css path %@",savePath);
        NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
        
        //把下载的内容从cache复制到document下
        
        [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
        
        if (!saveError) {
            if (strongSelf.downLoadBlock) {
               
                strongSelf.downLoadBlock(YES,[strongSelf cachePath]);
            }
//            NSLog(@"save success");
            
        }else{
            if (strongSelf.downLoadBlock) {
                strongSelf.downLoadBlock(NO,nil);
            }
            NSLog(@"save error:%@",saveError.localizedDescription);
            
        }
//    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask

      didWriteData:(int64_t)bytesWritten

 totalBytesWritten:(int64_t)totalBytesWritten

totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    NSLog(@"%@",[NSString stringWithFormat:@"下载进度:%f",(double)totalBytesWritten/totalBytesExpectedToWrite]);
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask

 didResumeAtOffset:(int64_t)fileOffset

expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

@end
