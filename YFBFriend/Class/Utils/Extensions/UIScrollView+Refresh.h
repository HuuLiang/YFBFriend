//
//  UIScrollView+Refresh.m
//  PPVideo
//
//  Created by Liang on 16/6/24.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)YFB_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)YFB_triggerPullToRefresh;
- (void)YFB_endPullToRefresh;

- (void)YFB_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)YFB_pagingRefreshNoMoreData;

- (void)YFB_addIsRefreshing;

- (void)YFB_addVIPNotiRefreshWithHandler:(void (^)(void))handler;

//- (void)YFB_addVipDetailNotiWithVipLevel:(PPVipLevel)vipLevel RefreshWithHandler:(void (^)(void))handler;

@end
