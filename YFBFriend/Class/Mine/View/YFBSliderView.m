//
//  YFBAttentionHeaderView.m
//  YFBFriend
//
//  Created by ylz on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSliderView.h"

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))/** 随机色  */
static CGFloat const titleH = 44;/** 文字高度  */

static CGFloat const MaxScale = 1.14;/** 选中文字放大  */

@interface YFBSliderView ()<UIScrollViewDelegate>

{
    UILabel *_receivedLabel;
    UILabel *_sendLabel;
}

@property (nonatomic, strong) UIScrollView *giftScrollView;
@property (nonatomic,assign,getter=isCanScroll) BOOL canScroll;//判断titleScroll是否可以滚动
@property (nonatomic) BOOL isGiftVC;
@property (nonatomic) CGFloat giftH;

@end


@implementation YFBSliderView

- (instancetype)initWithIsGiftVC:(BOOL)isGiftVC
{
    self = [super init];
    if (self) {
        _isGiftVC = isGiftVC;
        _giftH = isGiftVC ? 36 : 0;
        
    }
    return self;
}

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setSlideHeadView{
    
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleScrollView];        /** 添加文字标签  */
    
    [self setContentScrollView];      /** 添加scrollView  */
    
    [self setupTitle];                /** 设置标签按钮 文字 背景图  */
    
    
    self.contentScrollView.contentSize = CGSizeMake(self.titlesArr.count * kScreenWidth, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = YES;
    
}
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

#pragma mark - PRIVATE

-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle{
    UIViewController *superVC = [self findViewController:self];
    childVC.title = vcTitle;
    [superVC addChildViewController:childVC];
    
}
-(void)setTitleScrollView{
    UIViewController *superVC = [self findViewController:self];
    CGRect rect  = CGRectMake(0, 0, kScreenWidth, titleH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    _titleScrollView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleH-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = kColor(@"#e6e6e6");
    [_titleScrollView addSubview:lineView];
    [superVC.view addSubview:self.titleScrollView];
    if (_isGiftVC) {
        CGRect giftRect = CGRectMake(0, titleH, kScreenWidth *2, _giftH);
        self.giftScrollView = [[UIScrollView alloc] initWithFrame:giftRect];
        _giftScrollView.backgroundColor = kColor(@"#eeeeee");
        [superVC.view addSubview:_giftScrollView];
        _receivedLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth *0.3)/2.,kWidth(35)/2., kScreenWidth*0.7, kWidth(32))];
        //        _receivedLabel.backgroundColor = [UIColor redColor];
        _receivedLabel.font = kFont(14);
        _receivedLabel.textAlignment = NSTextAlignmentCenter;
        [_giftScrollView addSubview:_receivedLabel];
        
        _sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth + (kScreenWidth *0.3)/2.,kWidth(35)/2., kScreenWidth*0.7, kWidth(32))];
        _sendLabel.font = kFont(14);
        _sendLabel.textAlignment = NSTextAlignmentCenter;
        [_giftScrollView addSubview:_sendLabel];
        self.giftScrollView.contentSize = CGSizeMake(_giftScrollView.size.width*1.5, 0);
        self.giftScrollView.showsHorizontalScrollIndicator = NO;
        self.giftScrollView.bounces = YES;
    }
    
}
-(void)setContentScrollView{
    UIViewController *superVC = [self findViewController:self];
    
    CGFloat y  = _isGiftVC ? CGRectGetMaxY(self.giftScrollView.frame) : CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect  = CGRectMake(0, y, kScreenWidth, kScreenHeight - titleH - _giftH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [superVC.view addSubview:self.contentScrollView];
    
    
}

-(void)setupTitle{
    UIViewController *superVC = [self findViewController:self];
    
    NSUInteger count = superVC.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = 80;
    NSInteger a = kScreenWidth / w;
    if (a >= count) {
        w = kScreenWidth /count;
    }
    _canScroll = count > a;
    
    
    CGFloat h = titleH;
    self.imageBackView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleH-2, (kScreenWidth)/2., 2)];
    _imageBackView.backgroundColor = kColor(@"#8458d0");
    _imageBackView.layer.cornerRadius = 5;
    _imageBackView.layer.masksToBounds = YES;
    self.imageBackView.userInteractionEnabled = YES;
    [self.titleScrollView addSubview:self.imageBackView];
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = superVC.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.];
        
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        
        if (i == 0)
        {
            [self click:btn];
        }
        
    }
    
    
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
}
- (void)click:(UIButton *)sender{
    
    [self selectTitleBtn:sender];
    NSInteger i = sender.tag;
    CGFloat x  = i *kScreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    [self setUpOneChildController:i];
}

- (void)currentVCWithIndex:(NSInteger)index {
    UIButton *sender = self.buttons[index];
    [self selectTitleBtn:sender];
    NSInteger i = sender.tag;
    CGFloat x  = i *kScreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    [self setUpOneChildController:i];
}

-(void)selectTitleBtn:(UIButton *)btn{
    
    
    [self.selectedBtn setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    self.selectedBtn.transform = CGAffineTransformIdentity;
    
    
    [btn setTitleColor:kColor(@"#8458d0") forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectedBtn = btn;
    
    [self setupTitleCenter:btn];
    
}

-(void)setupTitleCenter:(UIButton *)sender
{
    if (!self.isCanScroll) {
        return;
    }
    CGFloat offset = sender.center.x - kScreenWidth * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset  = self.titleScrollView.contentSize.width - kScreenWidth;
    if (offset > maxOffset && maxOffset>0) {
        offset = maxOffset;
    }
    
    //    NSLog(@"%lf,%lf,%ld",offset,maxOffset,sender.tag);
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
}

-(void)setUpOneChildController:(NSInteger)index{
    UIViewController *superVC = [self findViewController:self];
    
    CGFloat x  = index * kScreenWidth;
    UIViewController *vc  =  superVC.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    //
    CGRect rect = CGRectMake(x, 0, kScreenWidth, kScreenHeight - self.contentScrollView.frame.origin.y);
    vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.contentScrollView.frame.origin.y - 115);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [self.contentScrollView addSubview:view];
    [view addSubview:vc.view];
}


#pragma mark - UIScrollView  delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger i  = self.contentScrollView.contentOffset.x / kScreenWidth;
    [self selectTitleBtn:self.buttons[i]];
    [self setUpOneChildController:i];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSInteger leftIndex  = offsetX / kScreenWidth;
    NSInteger rightIdex  = leftIndex + 1;
    
    UIButton *leftButton = self.buttons[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIdex < self.buttons.count) {
        rightButton  = self.buttons[rightIdex];
    }
    CGFloat scaleR  = offsetX / kScreenWidth - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = MaxScale - 1.;
    
    self.imageBackView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width)), 0);
    
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    [self.giftScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    //    UIColor *rightColor = [UIColor colorWithRed:(174+66*scaleR)/255.0 green:(174-71*scaleR)/255.0 blue:(174-174*scaleR)/255.0 alpha:1];
    //    UIColor *leftColor = [UIColor colorWithRed:(174+66*scaleL)/255.0 green:(174-71*scaleL)/255.0 blue:(174-174*scaleL)/255.0 alpha:1];
    //
    //    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    //    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    //
}

- (void)setReceivedGift:(NSString *)receivedGift {
    _receivedGift = receivedGift;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前收到的礼物:  %@个",receivedGift]];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : kColor(@"#9d9d9d")} range:NSMakeRange(9, attributeStr.length - 9)];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : kColor(@"#333333")} range:NSMakeRange(0, 9)];
    _receivedLabel.attributedText = attributeStr;
}

- (void)setSendGift:(NSString *)sendGift {
    _sendGift = sendGift;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前送出的礼物:  %@个",sendGift]];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : kColor(@"#9d9d9d")} range:NSMakeRange(9, attributeStr.length - 9)];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : kColor(@"#333333")} range:NSMakeRange(0, 9)];
    _sendLabel.attributedText = attributeStr;
}

@end
