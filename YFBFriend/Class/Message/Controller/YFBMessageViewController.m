//
//  YFBMessageViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageViewController.h"
#import "YFBMessageModel.h"
#import "YFBMessageAdView.h"
#import "YFBMessageFunctionView.h"
#import "YFBGiftPopViewController.h"
#import "YFBMessagePayPopController.h"
#import "YFBInteractionManager.h"
#import "YFBVipViewController.h"
#import "YFBGiftManager.h"
#import "YFBMessageRecordManager.h"
#import "YFBExampleManager.h"
#import "YFBNavigationController.h"
#import "YFBContactManager.h"
#import "YFBWordsObserve.h"

@interface YFBMessageViewController ()
{
    YFBGiftPopViewController *_giftVC;
    UIView *_payView;
}
@property (nonatomic,retain) NSMutableArray<YFBMessageModel *> *chatMessages;
@property (nonatomic,retain) YFBMessageAdView *messagAdView;
@property (nonatomic,retain) YFBMessageFunctionView *functionView;
@property (nonatomic) BOOL needReturn;
@end

@implementation YFBMessageViewController
QBDefineLazyPropertyInitialization(NSMutableArray, chatMessages)

+ (instancetype)showMessageWithUserId:(NSString *)userId
                             nickName:(NSString *)nickName
                            avatarUrl:(NSString *)avatarUrl
                     inViewController:(UIViewController *)viewController {
    YFBMessageViewController *messageVC = [[self alloc] initWithUserId:userId nickName:nickName avatarUrl:avatarUrl];
    messageVC.allowsSendFace = NO;
    messageVC.allowsSendMultiMedia = NO;
    messageVC.allowsSendVoice = NO;
    [viewController.navigationController pushViewController:messageVC animated:YES];
    return messageVC;

}

+ (instancetype)presentMessageWithUserId:(NSString *)userId
                                nickName:(NSString *)nickName
                               avatarUrl:(NSString *)avatarUrl
                        inViewController:(UIViewController *)viewController {
    YFBMessageViewController *messageVC = [[self alloc] initWithUserId:userId nickName:nickName avatarUrl:avatarUrl];
    messageVC.needReturn = YES;
    messageVC.allowsSendFace = NO;
    messageVC.allowsSendMultiMedia = NO;
    messageVC.allowsSendVoice = NO;
    YFBNavigationController *messageNav = [[YFBNavigationController alloc] initWithRootViewController:messageVC];
    [viewController presentViewController:messageNav animated:YES completion:nil];
    return messageVC;
}

- (instancetype)initWithUserId:(NSString *)userId nickName:(NSString *)nickName avatarUrl:(NSString *)avatarUrl {
    self = [self init];
    if (self) {
        _userId = userId;
        _nickName = nickName;
        _avatarUrl = avatarUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.nickName;
    self.messageSender = [YFBUser currentUser].userId;
    
    [self configFunctionUI];
    
    if (_needReturn) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChatMessages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiamondCount) name:kYFBUpdateMessageDiamondCountNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _messagAdView.scrollStart = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _messagAdView.scrollStart = NO;
    
    YFBMessageModel *lastMessage = [self.chatMessages lastObject];
    YFBContactModel *contactModel = [[YFBContactManager manager] findContactInfoWithUserId:self.userId];
    
    contactModel.portraitUrl = self.avatarUrl;
    contactModel.nickName = self.nickName;
    contactModel.userId = self.userId;
    
    if (lastMessage.messageType <= YFBMessageTypePhoto && lastMessage != nil) {
        //时间
        contactModel.messageTime = lastMessage.messageTime;
        //内容
        if (lastMessage.messageType == YFBMessageTypeText) {
            contactModel.messageContent = lastMessage.content;
        } else if (lastMessage.messageType == YFBMessageTypePhoto) {
            contactModel.messageContent = @"[图片]";
        }

    }
    contactModel.unreadMsgCount = 0;
    [contactModel saveOrUpdate];
    
    //向消息界面发出通知更改角标数字
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateContactUnReadMessageNotification object:contactModel];
}

- (void)reloadChatMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.chatMessages = [YFBMessageModel allMessagesWithUserId:self.userId].mutableCopy;
        [self.messages removeAllObjects];
        [self.chatMessages enumerateObjectsUsingBlock:^(YFBMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XHMessage *message;
            NSDate *date = [YFBUtil dateFromString:obj.messageTime WithDateFormat:KDateFormatLong];
            if (obj.messageType == YFBMessageTypeText) {
                message = [[XHMessage alloc] initWithText:obj.content
                                                   sender:obj.sendUserId
                                                timestamp:date];
                message.messageMediaType = XHBubbleMessageMediaTypeText;
            } else if (obj.messageType == YFBMessageTypePhoto) {
                message = [[XHMessage alloc] initWithPhoto:nil
                                              thumbnailUrl:obj.content
                                            originPhotoUrl:nil
                                                    sender:obj.sendUserId
                                                 timestamp:date];
            }
            
            if ([obj.sendUserId isEqualToString:[YFBUser currentUser].userId]) {
                message.bubbleMessageType = XHBubbleMessageTypeSending;
            } else {
                message.bubbleMessageType = XHBubbleMessageTypeReceiving;
            }
            
            [self.messages addObject:message];
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.messageTableView reloadData];
            [self scrollToBottomAnimated:NO];
        });
    });
}


- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSString *)dateTime {
    YFBMessageModel *chatMessage = [[YFBMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = YFBMessageTypeText;
    chatMessage.content = message;
    
    [self addChatMessage:chatMessage];
}

- (void)addChatMessage:(YFBMessageModel *)chatMessage {
    //判断是否需要进行VIP状态检测
    //如果信息接受者是机器人则需要
    __block YFBMessageRecordType recordType;
    NSInteger messageDiamondCount = 0;
    if ([chatMessage.receiveUserId isEqualToString:self.userId]) {
        recordType = [[YFBMessageRecordManager manager] checkMessageRecordWithChatMessages:self.chatMessages thisMessage:chatMessage];
        if (recordType <= YFBMessageRecordTypeAllowVip) {
            [chatMessage saveOrUpdate];
            [self.chatMessages addObject:chatMessage];
            if (recordType == YFBMessageRecordTypeAllowDiamond) {
                messageDiamondCount = -80;
            } else if (recordType == YFBMessageRecordTypeAllowVip) {
                messageDiamondCount = -1;
            }
        } else if (recordType == YFBMessageRecordTypeBuyDiamond) {
            [self showPayVipViewWithType:YFBMessagePopViewTypeBuyDiamond];
            QBLog(@"购买钻石");
            return;
        } else if (recordType == YFBMessageRecordTypeBuyVip) {
            [self showPayVipViewWithType:YFBMessagePopViewTypeVip];
            QBLog(@"购买VIP");
            return;
        } else {
            return;
        }
    } else {
        //如果不是机器人则不需要
        [chatMessage saveOrUpdate];
        [self.chatMessages addObject:chatMessage];
    }
    
    if (self.isViewLoaded) {
        @weakify(self);
        [[YFBInteractionManager manager] sendMessageInfoToUserId:chatMessage.receiveUserId content:chatMessage.content type:chatMessage.messageType deductDiamonds:messageDiamondCount handler:^(BOOL success) {
            @strongify(self);
            if (success) {
                //刷新上部功能菜单里的钻石数量
                [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                
                //保存已发送消息到消息记录管理里面
                [self saveMessageInfo:chatMessage WithRecordType:recordType];
                
                //检测发送消息关键词
                [[YFBWordsObserve observe] checkMessageContent:chatMessage];
                
                XHMessage *xhMsg;
                NSDate *date = [YFBUtil dateFromString:chatMessage.messageTime WithDateFormat:KDateFormatLong];
                if (chatMessage.messageType == YFBMessageTypeText) {
                    xhMsg = [[XHMessage alloc] initWithText:chatMessage.content
                                                     sender:chatMessage.sendUserId
                                                  timestamp:date];
                } else if (chatMessage.messageType == YFBMessageTypePhoto) {
                    xhMsg = [[XHMessage alloc] initWithPhoto:nil
                                                thumbnailUrl:chatMessage.content
                                              originPhotoUrl:nil
                                                      sender:chatMessage.sendUserId
                                                   timestamp:date];
                }
                
                if ([chatMessage.sendUserId isEqualToString:[YFBUser currentUser].userId]) {
                    xhMsg.bubbleMessageType = XHBubbleMessageTypeSending;
                } else {
                    xhMsg.bubbleMessageType = XHBubbleMessageTypeReceiving;
                }
                
                [self addMessage:xhMsg];
            } else {
                [[YFBHudManager manager] showHudWithText:@"消息发送失败"];
            }
        }];
    }
}

- (void)saveMessageInfo:(YFBMessageModel *)messageModel WithRecordType:(YFBMessageRecordType)type {
    YFBMessageRecordModel *recordModel = [[YFBMessageRecordModel alloc] init];
    recordModel.messageTime = [YFBUtil timeStringFromDate:[YFBUtil dateFromString:messageModel.messageTime WithDateFormat:KDateFormatLong] WithDateFormat:KDateFormatShortest];
    recordModel.userId = messageModel.receiveUserId;
    recordModel.type = type;
    [recordModel saveOrUpdate];
}

- (void)addPhoneOrWxWithMessageType:(YFBMessageFunciontType)type {
    NSString *contactType = nil;
    if (type == YFBMessageFunciontTypePhone) {
        contactType = kYFBFriendReferContactPhoneKeyName;
    } else if (type == YFBMessageFunciontTypeWX) {
        contactType = kYFBFriendReferContactWXKeyName;
    }

    @weakify(self);
    [[YFBInteractionManager manager] referUserContactWithType:contactType toUserId:self.userId handler:^(BOOL success, NSString *contact) {
        @strongify(self);
        NSString *content = nil;
        if ([contact isEqualToString:@"用户尚未设置"]) {
            [[YFBHudManager manager] showHudWithText:@"用户尚未设置"];
            return ;
        }
        if (type == YFBMessageFunciontTypePhone) {
            content = [NSString stringWithFormat:@"我的手机号是%@",contact];
        } else if (type == YFBMessageFunciontTypeWX) {
            content = [NSString stringWithFormat:@"我的微信号是%@",contact];
        }
        [self addTextMessage:content withSender:self.userId receiver:[YFBUser currentUser].userId dateTime:[YFBUtil timeStringFromDate:[NSDate date] WithDateFormat:KDateFormatLong]];
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
        [self scrollToBottomAnimated:YES];
    }];
}

- (void)configFunctionUI {
    self.messagAdView = [[YFBMessageAdView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(48))];
    _messagAdView.recordsArr = [YFBExampleManager manager].giftExampleSource;
    [self.view addSubview:_messagAdView];
    
    self.functionView = [[YFBMessageFunctionView alloc] initWithFrame:CGRectMake(0, kWidth(48), kScreenWidth, kWidth(72))];
    _functionView.diamondCount = [YFBUser currentUser].diamondCount;
    @weakify(self);
    _functionView.functionType = ^(YFBMessageFunciontType type) {
        @strongify(self);
        switch (type) {
            case YFBMessageFunciontTypeAttention:
                [[YFBInteractionManager manager] concernUserWithUserId:self.userId handler:^(BOOL success) {
                    if (success) {
                        [[YFBHudManager manager] showHudWithText:@"关注成功"];
                    }
                }];
                break;
                
            case YFBMessageFunciontTypeDiamon:
                [YFBMessagePayPopController showMessageTopUpPopViewWithType:YFBMessagePopViewTypeDiamond onCurrentVC:self];
                break;
                
            case YFBMessageFunciontTypePhone:
                if ([YFBUtil isVip]) {
                    [self addPhoneOrWxWithMessageType:YFBMessageFunciontTypePhone];
                } else {
                    [YFBMessagePayPopController showMessageTopUpPopViewWithType:YFBMessagePopViewTypeVip onCurrentVC:self];
                }
                
                break;
            
            case YFBMessageFunciontTypeWX:
                if ([YFBUtil isVip]) {
                    [self addPhoneOrWxWithMessageType:YFBMessageFunciontTypeWX];
                } else {
                    [YFBMessagePayPopController showMessageTopUpPopViewWithType:YFBMessagePopViewTypeVip onCurrentVC:self];
                }
                
                
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_functionView];
}

//刷新上部功能菜单里的钻石数量
- (void)updateDiamondCount {
    if (self.functionView) {
        _functionView.diamondCount = [YFBUser currentUser].diamondCount;
    }
    if (self.messageInputView.hidden) {
        self.messageInputView.hidden = NO;
        if ([self.view.subviews containsObject:_payView]) {
            [_payView removeFromSuperview];
        }
        
        if (_payView) {
            _payView = nil;
        }
    }
}

- (void)popGiftView {
    if (self.messageInputView.inputTextView.isFirstResponder) {
        [self.messageInputView.inputTextView resignFirstResponder];
    }
    
    _giftVC = [[YFBGiftPopViewController alloc] init];
    [_giftVC showGiftViewWithType:YFBGiftPopViewTypeList InCurrentViewController:self];
    @weakify(self);
    _giftVC.payAction = ^{
        @strongify(self);
        [YFBMessagePayPopController showMessageTopUpPopViewWithType:YFBMessagePopViewTypeDiamond onCurrentVC:self];
    };
    _giftVC.sendGiftAction = ^(YFBGiftInfo * giftInfo) {
        @strongify(self);
        if (giftInfo.diamondCount <= [YFBUser currentUser].diamondCount) {
            [[YFBInteractionManager manager] sendMessageInfoToUserId:self.userId content:giftInfo.giftId type:YFBMessageTypeGift deductDiamonds:-giftInfo.diamondCount handler:^(BOOL success) {
                if (success) {
                    [[YFBHudManager manager] showHudWithText:@"礼物赠送成功"];
                    //刷新上部功能菜单里的钻石数量 即礼物赠送界面的钻石数量
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                }
            }];
        } else {
            [YFBMessagePayPopController showMessageTopUpPopViewWithType:YFBMessagePopViewTypeDiamond onCurrentVC:self];
        }
    };
}

- (void)showPayVipViewWithType:(YFBMessagePopViewType)type {
    if (self.messageInputView.inputTextView.isFirstResponder) {
        [self.messageInputView.inputTextView resignFirstResponder];
    }
    CGRect payFrame = self.messageInputView.frame;
    self.messageInputView.hidden = YES;
    
    _payView = [[UIView alloc] initWithFrame:payFrame];
    [self.view addSubview:_payView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"回复并索要联系方式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@""] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    button.backgroundColor = [UIColor colorWithHexString:@"#8458D0"];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [_payView addSubview:button];
    
    @weakify(self);
    [button bk_addEventHandler:^(id sender) {
        @strongify(self);
        [YFBMessagePayPopController showMessageTopUpPopViewWithType:type onCurrentVC:self];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_payView);
        make.size.mas_equalTo(CGSizeMake(_payView.size.width*0.9, _payView.size.height * 0.9));
    }];
}

@end
