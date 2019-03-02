//
//  VENMyOrderCategoryView.m
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderCategoryView.h"

@interface VENMyOrderCategoryView ()
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation VENMyOrderCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)categoryBtnClick:(UIButton *)sender {
    
    // 获取按钮所在集合中的索引
    _pageNumber = [_btnsArr indexOfObject:sender];
    
    // 发送事件,让scrollView滚动!
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    // 让线动起来!
    self.offset_X = sender.bounds.size.width * _pageNumber;
    
    // 修改按钮状态!
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;
}

- (void)setOffset_X:(CGFloat)offset_X { // 重写偏移量的set方法,让线偏移
    
    _offset_X = offset_X;
    // 更新线约束
    // 更新线的约束,中心的x值
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btnsArr[0]).offset(offset_X);
    }];
    
    // 强制布局子控件
    // 需要通过动画修改布局时,给layoutIfNeed添加动画代码!
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    // 修改按钮的状态!
    // 计算通过偏移量得出对应的索引值
    NSInteger idx = offset_X / _btnsArr[0].bounds.size.width + 0.5;
    NSLog(@"%zd", idx); // 1 ~ 1.9   + 0.5  1.5
    
    // 修改按钮的状态
    // - 取消之前的
    _selectedBtn.selected = NO;
    // - 设置当前的
    _btnsArr[idx].selected = YES;
    // - 记录当前的
    _selectedBtn = _btnsArr[idx];
}

#pragma mark - 搭建界面
- (void)setupUI {
    // 1.确定按钮标题
    NSArray<NSString *> *titlesArr = @[@"全部", @"待发货", @"待收货", @"待评价"];
    // 2.遍历创建按钮
    [titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //   2.1 创建按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_THEME forState:UIControlStateSelected];
        [btn sizeToFit];
        
        // 2.2 添加按钮监听事件
        [btn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 2.3 如果是第0个按钮,设置个初始选中状态,记得赋值!
        if (idx == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        
        [self addSubview:btn];
    }];
    
    // 布局按钮的约束
    [self.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self);
        
    }];
    
    // 记录3个按钮
    _btnsArr = self.subviews;
    
    // 添加线条
    // 创建视图 线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_THEME;
    
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.equalTo(self.btnsArr[0]);
        make.height.mas_equalTo(2);
        make.centerX.equalTo(self.btnsArr[0]);
    }];
    
    // 线
    UIView *splitLineView = [[UIView alloc] init];
    splitLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addSubview:splitLineView];
    
    [splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(1);
    }];
    
    // 记录成员变量
    _lineView = lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
