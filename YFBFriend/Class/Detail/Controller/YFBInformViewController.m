//
//  YFBInformViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/6/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBInformViewController.h"
#import "YFBInteractionManager.h"

@interface YFBInformViewController ()
@property (nonatomic) UITextView *textView;
@property (nonatomic) UIButton *informButton;
@end

@implementation YFBInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configInformView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configInformView {
    self.textView = [[UITextView alloc] init];
    _textView.font = kFont(14);
    _textView.textColor = kColor(@"#333333");
    _textView.backgroundColor = kColor(@"#eeeeee");
    [self.view addSubview:_textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入你要举报内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = kColor(@"#cccccc");
    placeHolderLabel.font = kFont(14);
    [placeHolderLabel sizeToFit];
    [_textView addSubview:placeHolderLabel];
    [_textView setValue:placeHolderLabel forKey:@"placeholderLabel"];
    
    self.informButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_informButton setTitle:@"提交" forState:UIControlStateNormal];
    [_informButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _informButton.titleLabel.font = kFont(14);
    _informButton.backgroundColor = kColor(@"#8458D0");
    [self.view addSubview:_informButton];
    
    @weakify(self);
    [_informButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        //发送举报内容
        [[YFBInteractionManager manager] sendAdviceWithContent:self.textView.text Contact:self.userId handler:^(BOOL success) {
            @strongify(self);
            if (success) {
                if (!self) {
                    return ;
                }
                [[YFBHudManager manager] showHudWithText:@"发送成功"];
                self.textView.text = @"";
            }
            [[YFBHudManager manager] showHudWithText:@"发送失败"];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(72));
            make.size.mas_equalTo(CGSizeMake(kWidth(588), kWidth(266)));
        }];
        
        [_informButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_textView.mas_bottom).offset(kWidth(62));
            make.size.mas_equalTo(CGSizeMake(kWidth(482), kWidth(72)));
        }];
    }
}

@end
