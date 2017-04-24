//
//  YFBMessageViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageViewController.h"
#import "YFBMessageModel.h"
#import "YFBContactModel.h"
#import "YFBMessageAdView.h"
#import "YFBMessageFunctionView.h"
#import "YFBGiftPopViewController.h"
#import "YFBMessagePayPopController.h"

@interface YFBMessageViewController ()
@property (nonatomic,retain) NSMutableArray<YFBMessageModel *> *chatMessages;
@property (nonatomic,retain) YFBMessageAdView *messagAdView;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChatMessages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _messagAdView.scrollStart = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _messagAdView.scrollStart = NO;
}

- (void)reloadChatMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.chatMessages = [YFBMessageModel allMessagesWithUserId:self.userId].mutableCopy;
        [self.messages removeAllObjects];
        [self.chatMessages enumerateObjectsUsingBlock:^(YFBMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XHMessage *message;
            NSDate *date = [YFBUtil dateFromString:obj.messageTime WithDateFormat:KDateFormatLong];
            if (obj.messageType == JYMessageTypeText) {
                message = [[XHMessage alloc] initWithText:obj.content
                                                   sender:obj.sendUserId
                                                timestamp:date];
                message.messageMediaType = XHBubbleMessageMediaTypeText;
            } else if (obj.messageType == JYMessageTypePhoto) {
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
    chatMessage.messageType = JYMessageTypeText;
    chatMessage.content = message;
    
    [self addChatMessage:chatMessage];
}

- (void)addChatMessage:(YFBMessageModel *)chatMessage {
    [self.chatMessages addObject:chatMessage];
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg;
        NSDate *date = [YFBUtil dateFromString:chatMessage.messageTime WithDateFormat:KDateFormatLong];
        if (chatMessage.messageType == JYMessageTypeText) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.content
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
        } else if (chatMessage.messageType == JYMessageTypePhoto) {
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
    }
}

- (void)configFunctionUI {
    self.messagAdView = [[YFBMessageAdView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(48))];
    _messagAdView.recordsArr = @[@"11",@"22",@"33",@"44",@"55"];
    [self.view addSubview:_messagAdView];
    
    YFBMessageFunctionView *functionView = [[YFBMessageFunctionView alloc] initWithFrame:CGRectMake(0, kWidth(48), kScreenWidth, kWidth(72))];
    @weakify(self);
    functionView.functionType = ^(YFBMessageFunciontType type) {
        @strongify(self);
        switch (type) {
            case YFBMessageFunciontTypeAttention:
                
                break;
                
            case YFBMessageFunciontTypeYBi:
                
                break;
                
            case YFBMessageFunciontTypePhone:
                
                break;
            
            case YFBMessageFunciontTypeWX:
                
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:functionView];
}

- (void)popGiftView {
    if (self.messageInputView.inputTextView.isFirstResponder) {
        [self.messageInputView.inputTextView resignFirstResponder];
    }
//    [YFBGiftPopViewController showGiftViewInCurrentViewController:self isMessagePop:YES];
    [self showPayView];
}

- (void)showPayView {
    if (self.messageInputView.inputTextView.isFirstResponder) {
        [self.messageInputView.inputTextView resignFirstResponder];
    }
    CGRect payFrame = self.messageInputView.frame;
    self.messageInputView.hidden = YES;
    
    UIView *payView = [[UIView alloc] initWithFrame:payFrame];
    [self.view addSubview:payView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"回复并索要联系方式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@""] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    button.backgroundColor = [UIColor colorWithHexString:@"#8458D0"];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [payView addSubview:button];
    
    @weakify(self);
    [button bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[[YFBMessagePayPopController alloc] init] showMessageTopUpPopViewWithCurrentVC:self];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(payView);
        make.size.mas_equalTo(CGSizeMake(payView.size.width*0.9, payView.size.height * 0.9));
    }];
}

@end
