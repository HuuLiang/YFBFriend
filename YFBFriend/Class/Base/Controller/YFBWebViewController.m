//
//  YFBWebViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/5/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBWebViewController.h"

@interface YFBWebViewController ()
{
    UIWebView *_webView;
}
@end

@implementation YFBWebViewController

- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl {
    self = [self init];
    if (self) {
        _url = url;
        _standbyUrl = standbyUrl;
    }
    return self;
}
- (instancetype)initWithHTML:(NSString *)htmlString {
    self = [super init];
    if (self) {
        _htmlString = htmlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    
    if (_htmlString.length > 0) {
        [_webView loadHTMLString:_htmlString baseURL:nil];
    } else {
        NSURLRequest *urlReq = [NSURLRequest requestWithURL:_url];
        NSURLRequest *standUrlReq = [NSURLRequest requestWithURL:_standbyUrl];
        
        if (_standbyUrl) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSHTTPURLResponse *response;
                NSError *error;
                [NSURLConnection sendSynchronousRequest:urlReq returningResponse:&response error:&error];
                NSInteger responseCode = response.statusCode;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (responseCode == 502 || responseCode == 404) {
                        [_webView loadRequest:standUrlReq];
                    } else {
                        [_webView loadRequest:urlReq];
                    }
                });
            });
        } else {
            [_webView loadRequest:urlReq];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
