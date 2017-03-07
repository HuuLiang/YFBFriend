//
//  JYVideoChatViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYVideoChatViewController.h"
#import "JYVideoChatView.h"
#import <AVFoundation/AVFoundation.h>   

@interface JYVideoChatViewController ()
{
    NSString *_nickName;
    NSString *_headerImageUrl;
}
@property (nonatomic,retain) JYVideoChatView *chatView;

@end

@implementation JYVideoChatViewController

- (JYVideoChatView *)chatView {
    if (_chatView) {
        return _chatView;
    }
    
    _chatView = [[JYVideoChatView alloc] init];
 
    [self.view addSubview:_chatView];
    {
    [_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    return _chatView;
}

- (instancetype)initWithNickName:(NSString *)nickName headerImageUrl:(NSString *)headerImageUrl {
    if (self = [super init]) {
        _headImageUrl = headerImageUrl;
        _nickName = nickName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.chatView.nickName = _nickName;
    self.chatView.headerImageUrl = _headImageUrl;
    self.chatView.chatState = @"等待对方接听...";
    @weakify(self);
    self.chatView.action = ^(id sender){
        @strongify(self);
        [self dismiss];
    };
    [self performSelector:@selector(triggerShake) withObject:nil afterDelay:1.];//延时1秒后震动
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)triggerShake {
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)dismiss{
    if (self.closeAction) {
        self.closeAction(@1);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);//挂断
}

void systemAudioCallback()//连续震动
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
