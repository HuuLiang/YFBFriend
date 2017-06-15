//
//  YFBFaceTimeView.m
//  YFBFriend
//
//  Created by Liang on 2017/6/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBFaceTimeView.h"
#import "YFBAutoReplyManager.h"
#import "YFBVipViewController.h"
#import "YFBNavigationController.h"
#import <AVFoundation/AVFoundation.h>

@interface YFBFaceTimeView ()

@property (nonatomic) UIImageView *backImgV;
@property (nonatomic) UIView *shadowView;

@property (nonatomic) UIImageView *userImgV;
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UIImageView *refuseImgV;
@property (nonatomic) UILabel *refuseLabel;
@property (nonatomic) UIImageView *answerImgV;
@property (nonatomic) UILabel *answerLabel;
@end

@implementation YFBFaceTimeView

+ (void)showFaceTimeViewWith:(YFBAutoReplyMessage *)messageModel InCurrentViewController:(UIViewController *)viewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        YFBFaceTimeView *faceTimeView = [[YFBFaceTimeView alloc] initWithInfo:messageModel];
        faceTimeView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [viewController.view addSubview:faceTimeView];
        
        @weakify(faceTimeView);
        faceTimeView.refuseAction = ^{
            @strongify(faceTimeView);
            [faceTimeView removeFromSuperview];
        };
        
        faceTimeView.answerAction = ^{
            @strongify(faceTimeView);
            [faceTimeView removeFromSuperview];
            
            viewController.modalPresentationStyle = UIModalPresentationFormSheet;
            viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            YFBVipViewController *vipVC = [[YFBVipViewController alloc] initWithIsDredgeVipVC:YES];
            vipVC.needReturn = YES;
            YFBNavigationController *vipNav = [[YFBNavigationController alloc] initWithRootViewController:vipVC];
            if (viewController.presentedViewController == nil) {
                [viewController presentViewController:vipNav animated:YES completion:nil];
            }
        };
    });
}

- (instancetype)initWithInfo:(YFBAutoReplyMessage *)messageModel
{
    self = [super init];
    if (self) {
        
        self.backImgV = [[UIImageView alloc] init];
        _backImgV.userInteractionEnabled = YES;
        [_backImgV sd_setImageWithURL:[NSURL URLWithString:messageModel.content]];
        [self addSubview:_backImgV];
        
        self.shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [kColor(@"#1D1F26") colorWithAlphaComponent:0.88];
        [self addSubview:_shadowView];
        
        self.userImgV = [[UIImageView alloc] init];
        [_userImgV sd_setImageWithURL:[NSURL URLWithString:messageModel.portraitUrl] placeholderImage:[UIImage imageNamed:@"mine_default_avatar"]];
        _userImgV.layer.cornerRadius = 5;
        [self addSubview:_userImgV];
        
        self.nickLabel = [[UILabel alloc] init];
        _nickLabel.text = messageModel.nickName;
        _nickLabel.font = kFont(25);
        _nickLabel.textColor = kColor(@"#ffffff");
        [self addSubview:_nickLabel];
        
        self.descLabel = [[UILabel alloc] init];
        _descLabel.text = @"邀请你视频聊天";
        _descLabel.font = kFont(14);
        _descLabel.textColor = kColor(@"#ffffff");
        [self addSubview:_descLabel];
        
        self.refuseImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facetime_refuse"]];
        _refuseImgV.userInteractionEnabled = YES;
        [self addSubview:_refuseImgV];
        
        @weakify(self);
        [_refuseImgV bk_whenTapped:^{
            @strongify(self);
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);//挂断
            if (self.refuseAction) {
                self.refuseAction();
            }
        }];
        
        self.refuseLabel = [[UILabel alloc] init];
        _refuseLabel.text = @"拒 绝";
        _refuseLabel.font = kFont(12);
        _refuseLabel.textColor = kColor(@"#ffffff");
        _refuseLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_refuseLabel];
        
        [_refuseLabel bk_whenTapped:^{
            @strongify(self);
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);//挂断
            if (self.refuseAction) {
                self.refuseAction();
            }
        }];
        
        self.answerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facetime_answer"]];
        _answerImgV.userInteractionEnabled = YES;
        [self addSubview:_answerImgV];
        
        [_answerImgV bk_whenTapped:^{
            @strongify(self);
            if (self.answerAction) {
                self.answerAction();
            }
        }];
        
        self.answerLabel = [[UILabel alloc] init];
        _answerLabel.text = @"接 听";
        _answerLabel.font = kFont(12);
        _answerLabel.textColor = kColor(@"#ffffff");
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_answerLabel];
        
        [_answerLabel bk_whenTapped:^{
            @strongify(self);
            if (self.answerAction) {
                self.answerAction();
            }
        }];
        
        {
            [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(76));
                make.left.equalTo(self).offset(30);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userImgV);
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(16));
                make.height.mas_equalTo(_nickLabel.font.lineHeight);
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickLabel);
                make.top.equalTo(_nickLabel.mas_bottom).offset(kWidth(12));
                make.height.mas_equalTo(_descLabel.font.lineHeight);
            }];
            
            [_refuseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(44));
                make.left.equalTo(self).offset(kWidth(120));
                make.height.mas_equalTo(_refuseLabel.font.lineHeight);
            }];
            
            [_refuseImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_refuseLabel.mas_top).offset(-kWidth(18));
                make.centerX.equalTo(_refuseLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(44));
                make.right.equalTo(self).offset(-kWidth(120));
                make.height.mas_equalTo(_refuseLabel.font.lineHeight);
            }];
            
            [_answerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_answerLabel.mas_top).offset(-kWidth(18));
                make.centerX.equalTo(_answerLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [self performSelector:@selector(triggerShake) withObject:nil afterDelay:1.];//延时1秒后震动

        }
    }
    return self;
}

- (void)triggerShake {
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void systemAudioCallback()//连续震动
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}


@end