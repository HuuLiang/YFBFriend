//
//  YFBMessageViewController+XHBMessageDelegate.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageViewController+XHBMessageDelegate.h"
#import "YFBDetailViewController.h"
#import "YFBPhotoBrowse.h"
#import "YFBContactModel.h"

@implementation YFBMessageViewController (XHBMessageDelegate)


#pragma mark - XHMessageTableViewControllerDelegate

//发送文本
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addTextMessage:text withSender:sender receiver:self.userId dateTime:[YFBUtil timeStringFromDate:date WithDateFormat:KDateFormatLong]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    [self scrollToBottomAnimated:YES];
}

//是否显示时间轴
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHMessage *previousMessage = indexPath.row > 0 ? self.messages[indexPath.row-1] : nil;
    if (previousMessage) {
        XHMessage *currentMessage = self.messages[indexPath.row];
        if ([currentMessage.timestamp isEqualToDateIgnoringSecond:previousMessage.timestamp]) {
            return NO;
        }
    }
    return YES;
}

//配置cell样式
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    XHMessage *message = self.messages[indexPath.row];
    
    BOOL isCurrentUser = [message.sender isEqualToString:[YFBUser currentUser].userId];
    if (isCurrentUser) {
        [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:[YFBUser currentUser].userImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"login_userImage"]];
//        [cell.avatarButton setImage:[UIImage imageNamed:@"mine_default_avatar"] forState:UIControlStateNormal];
    } else {
        [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_default_avatar"]];;
    }
}

#pragma mark - XHMessageTableViewCellDelegate

/**
 *  点击多媒体消息的时候统一触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 *  @param messageTableViewCell 目标消息在该Cell上
 */
- (void)multiMediaMessageDidSelectedOnMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    if (message.messageMediaType == XHBubbleMessageMediaTypePhoto && message.thumbnailUrl) {
        //图片浏览
        [[YFBPhotoBrowse browse] showPhotoBrowseWithImageUrl:message.thumbnailUrl onSuperView:self.view];
    }
}

/**
 *  双击文本消息，触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didDoubleSelectedOnTextMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    //    XHMessage *message = self.messages[indexPath.row];
    
}

/**
 *  点击消息发送者的头像回调方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didSelectedAvatarOnMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isCurrentUser = [message.sender isEqualToString:[YFBUser currentUser].userId];
    
    if (isCurrentUser) {
        
    } else {
        YFBDetailViewController *detailVC = [[YFBDetailViewController alloc] initWithUserId:self.userId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
