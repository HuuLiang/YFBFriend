//
//  YFBChatTableViewCell.m
//  YFBFriend
//
//  Created by ylz on 2017/3/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBChatTableViewCell.h"

@interface YFBChatTableViewCell ()
@property (nonatomic, strong) UIView *mainView;

@end

@implementation YFBChatTableViewCell

+ (instancetype)createChatTableViewCellWithTableView:(UITableView *)tableView
{
    YFBChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDChatTableViewCell"];
    if (!cell) {
        cell = [[YFBChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDChatTableViewCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = kFont(13);
        self.textLabel.textColor = kColor(@"#999999");
        self.textLabel.transform = CGAffineTransformMakeScale(1, -1);
        [self setUpCellUI];
    }
    return self;
}

- (void)setUpCellUI {
    UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    cornerView.backgroundColor = [UIColor whiteColor];
    cornerView.layer.cornerRadius = 3.0;
    cornerView.layer.masksToBounds = YES;
    [self.contentView insertSubview:cornerView belowSubview:self.textLabel];
    self.mainView = cornerView;
}

- (void)setCellAttributTitle:(NSAttributedString *)str
{
    // 这里就不考虑多行的情况了，可以根据具体需求具体对待
    self.textLabel.attributedText = str;
    CGRect rect = [str.string boundingRectWithSize:CGSizeMake(0, 18) options: NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    self.mainView.frame = CGRectMake(0, 0, 30 + rect.size.width, 30);
}


@end
