//
//  WebView.h
//  H5App
//
//  Created by Blavtes on 2018/12/13.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^RemoveCall)(void);
@interface WebView : UIView
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, copy) RemoveCall removeCall;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)start;
@end

NS_ASSUME_NONNULL_END
