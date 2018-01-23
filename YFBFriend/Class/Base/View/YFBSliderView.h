//
//  YFBAttentionHeaderView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBSliderView : UIView

/** 文字scrollView  */
@property (nonatomic, strong) UIScrollView *titleScrollView;
/** 控制器scrollView  */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/** 标签文字  */
@property (nonatomic ,copy) NSArray * titlesArr;
/** 标签按钮  */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 选中的按钮  */
@property (nonatomic ,strong) UIButton * selectedBtn;
/** 选中的按钮背景图  */
@property (nonatomic ,strong) UIImageView * imageBackView;

//设置界面是否包含tabbar
@property (nonatomic,assign) CGFloat tabbarHeight;

-(void)setSlideHeadView;
-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle;

- (void)currentVCWithIndex:(NSInteger)index;
@end
