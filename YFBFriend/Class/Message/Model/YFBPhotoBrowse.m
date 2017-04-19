//
//  YFBPhotoBrowse.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPhotoBrowse.h"


@interface YFBPhotoBrowse ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation YFBPhotoBrowse

+ (instancetype)browse {
    static YFBPhotoBrowse *_browse;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _browse = [[YFBPhotoBrowse alloc] init];
    });
    return _browse;
}

- (void)showPhotoBrowseWithImageUrl:(NSString *)imageUrl onSuperView:(UIView *)superView {
    self.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [superView.window addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    
    self.imageView = [[UIImageView alloc] initWithFrame:superView.window.bounds];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    @weakify(self);
    [self bk_whenTapped:^{
        @strongify(self);
        [self closeBrowse];
    }];
    
    [_imageView bk_whenTapped:^{
        @strongify(self);
        [self closeBrowse];
    }];

}

- (void)closeBrowse {
    if (self.closeAction) {
        self.closeAction(self);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_imageView removeFromSuperview];
        _imageView = nil;
    }];

}

@end
