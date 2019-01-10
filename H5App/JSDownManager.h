//
//  JSDownManager.h
//  H5App
//
//  Created by Blavtes on 2019/1/10.
//  Copyright © 2019 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DownLoadBlock)(BOOL cache, NSString *path);
@interface JSDownManager : NSObject
@property (nonatomic, strong) NSString *downLoadPath;
@property (nonatomic, strong) NSString *downLoadEndPath;
@property (nonatomic, copy) DownLoadBlock downLoadBlock;
- (void)downloadFileWithURL:(NSString *)urlStr downLoadBlock:(DownLoadBlock)block;

@end

NS_ASSUME_NONNULL_END
