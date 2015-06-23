//
//  MYTabBar.m
//  仿写腾讯新闻tabBar拖动效果
//
//  Created by 塔利班 on 15/6/12.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#import "MYTabBar.h"
#import "MYTabBarButton.h"

// 系统item的默认title前缀
NSString *const systemItemTitlePrefix = @"Item";

// 按钮不同状态的key
NSString *const stateNormal = @"UIControlStateNormal";
NSString *const stateHighlighted = @"UIControlStateHighlighted";
NSString *const stateDisabled = @"UIControlStateDisabled";
NSString *const stateSelected = @"UIControlStateSelected";
NSString *const stateApplication = @"UIControlStateApplication";
NSString *const stateReserved = @"UIControlStateReserved";

// 归位的动画时间
static const CGFloat kAnimationDuration = 0.2;

// 用来保存自身的item数组
static NSArray *instance;

@interface MYTabBar ()
// 自定义tabBarButton数组
@property (nonatomic, strong) NSMutableArray *btns;
// 选中状态的tabBarButton
@property (nonatomic, weak) MYTabBarButton *selectedBtn;
// 上一次的接触点
@property (nonatomic, assign) CGPoint lastTouchPoint;
// 拖拽按钮
@property (nonatomic, weak) UIButton *moveBtn;
// 是否为换位
@property (nonatomic, assign, getter=isChanging) BOOL changing;
// 选中按钮要移动到的frame
@property (nonatomic, assign) CGRect destFrame;
// 按钮属性的字典
@property (nonatomic, strong) NSMutableDictionary *attributes;
@end

@implementation MYTabBar

#pragma mark - LazyLoad

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableDictionary *)attributes
{
    if (_attributes == nil) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return _attributes;
}

#pragma mark - LifeCircle Method

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 模糊效果
        self.translucent = NO;
        // 背景色
        self.barTintColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - System Method

/**
 *  系统传递来所有的item模型
 *
 *  重写方法，添加自己的tabBarButton
 *  @param animated
 */
- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    // 添加自定义tabBarButton
    for (int i = 0; i < items.count; i++) {
        // item模型
        UITabBarItem *item = items[i];
        item.tag = i;
        if ([item.title hasPrefix:systemItemTitlePrefix]) {
            item.title = nil;
        }
        // 创建tabBarButton
        MYTabBarButton *btn = [MYTabBarButton tabBarButtonWithImageViewTopMargin:self.tabBarButtonImageViewTopMargin titleLabelTopMargin:self.tabBarButtonTitleLableTopMargin];
        // 设置图片
        btn.tag = i;
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        [btn setTitle:item.title forState:UIControlStateNormal];
        // 设置titleText
        if (self.attributes[stateNormal]) {
            [btn setTitleColor:self.attributes[stateNormal][NSForegroundColorAttributeName] forState:UIControlStateNormal];
            btn.titleLabel.font = self.attributes[stateNormal][NSFontAttributeName];
        }
        if (self.attributes[stateSelected]) {
            [btn setTitleColor:self.attributes[stateSelected][NSForegroundColorAttributeName] forState:UIControlStateSelected];
        }
        // 添加
        [self addSubview:btn];
        [self.btns addObject:btn];
        // 监听
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        // 添加长按手势
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        lp.minimumPressDuration = 1;  // 设置长按时间
        [btn addGestureRecognizer:lp];
    }
    // 因为这个方法调用super会产生系统的tabBarButton,不调用super系统的items数组为nil,所以这样处理
    instance = items;
}

/**
 *  重写item模型数组get \ 保证可以返回获取到的items
 *
 *  @return
 */
- (NSArray *)items
{
    return instance;
}

/**
 *  选中某个自定义tabBarButton
 *
 *  @param selectedItem 自定义tabBarButton对应的item
 */
- (void)setSelectedItem:(UITabBarItem *)selectedItem
{
    // 获取角标
    NSUInteger index = [self.items indexOfObject:selectedItem];
    
    // 更换按钮
    self.selectedBtn.selected = NO;
    self.selectedBtn.backgroundColor = [UIColor whiteColor];
    UIButton *selectedBtn = self.btns[index];
    selectedBtn.selected = YES;
    selectedBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    self.selectedBtn = (MYTabBarButton *)selectedBtn;
}

#pragma mark - Public Method

+ (instancetype)tabBarWithTabBarButtonImageViewTopMargin:(CGFloat)tabBarButtonImageViewTopMargin tabBarButtonTitleLableTopMargin:(CGFloat)tabBarButtonTitleLableTopMargin
{
    MYTabBar *tabBar = [[self alloc] init];
    tabBar.tabBarButtonImageViewTopMargin = tabBarButtonImageViewTopMargin;
    tabBar.tabBarButtonTitleLableTopMargin = tabBarButtonTitleLableTopMargin;
    return tabBar;
}

/** 设置titleText的属性 */
- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
            [self.attributes setObject:attributes forKey:stateNormal];
            break;
        case UIControlStateHighlighted:
            [self.attributes setObject:attributes forKey:stateHighlighted];
            break;
        case UIControlStateDisabled:
            [self.attributes setObject:attributes forKey:stateDisabled];
            break;
        case UIControlStateSelected:
            [self.attributes setObject:attributes forKey:stateSelected];
            break;
        case UIControlStateApplication:
            [self.attributes setObject:attributes forKey:stateApplication];
            break;
        case UIControlStateReserved:
            [self.attributes setObject:attributes forKey:stateReserved];
            break;
        default:
            break;
    }
}

#pragma mark - Private Method

/**
 *  长按手势触发
 *
 *  @param lp 手势
 */
- (void)longPress:(UILongPressGestureRecognizer *)lp
{
    switch (lp.state) {
        case UIGestureRecognizerStateBegan:  // 手势开始
        {
            /* 创建出一个用于拖拽的tabBarButton */
            [self creatMoveBtn:lp];
        }
            break;
            case UIGestureRecognizerStateChanged:  // 开始拖拽
        {
            /** 实现拖拽 */
            CGPoint moveBtnCenter = [self adjustMoveBtnTransform:lp];
            /** 调整自定义tabBarButton的位置 */
            [self adjustTabBarButtonTransform:moveBtnCenter];
        }
            break;
            
            case UIGestureRecognizerStateEnded:  // 结束拖拽
        {
            // tabBarButton归位
            [UIView animateWithDuration:kAnimationDuration animations:^{
                if (self.isChanging) {
                    self.moveBtn.frame = self.destFrame;
                    self.selectedBtn.frame = [self convertRect:self.destFrame fromView:[UIApplication sharedApplication].keyWindow];
                } else {
                    self.moveBtn.transform = CGAffineTransformIdentity;
                }
            } completion:^(BOOL finished) {
                // 移除拖拽按钮
                [self.moveBtn removeFromSuperview];
                self.moveBtn = nil;
                // 显示tabBarButton
                self.selectedBtn.hidden = NO;
                // 换位完全结束,改变换位状态
                self.changing = NO;
            }];
        }
            default:
            break;
    }
}

/**
 *  创建移动的tabBarButton
 *
 *  @param lp 手势
 */
- (void)creatMoveBtn:(UILongPressGestureRecognizer *)lp
{
    // 真正的tabBarButton
    MYTabBarButton *btn = (MYTabBarButton *)lp.view;
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 坐标系从tabBarButton上转移到window上
    CGRect rect = [self convertRect:btn.frame toView:keyWindow];
    CGPoint center = [btn convertPoint:btn.touchPoint toView:keyWindow];
    // 创建拖拽按钮
    MYTabBarButton *moveBtn = [MYTabBarButton tabBarButtonWithImageViewTopMargin:btn.imageViewTopMargin titleLabelTopMargin:btn.titleLabelTopMargin];
    moveBtn.selected = YES;
    // 背景色
    moveBtn.backgroundColor = [UIColor whiteColor];
    // 设置titleText属性
    if (self.attributes[stateNormal]) {
        [moveBtn setTitleColor:self.attributes[stateNormal][NSForegroundColorAttributeName] forState:UIControlStateNormal];
        moveBtn.titleLabel.font = self.attributes[stateNormal][NSFontAttributeName];
    }
    if (self.attributes[stateSelected]) {
        [moveBtn setTitleColor:self.attributes[stateSelected][NSForegroundColorAttributeName] forState:UIControlStateSelected];
    }
    // 设置图片 标题 frame  阴影...
    [moveBtn setImage:btn.currentImage forState:UIControlStateSelected];
    [moveBtn setTitle:btn.titleLabel.text forState:UIControlStateSelected];
    moveBtn.frame = rect;
    moveBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    moveBtn.layer.shadowRadius = 7;
    moveBtn.layer.shadowOpacity = 1;
    moveBtn.layer.shadowOffset = CGSizeMake(0, 0.5);
    // 添加
    [keyWindow addSubview:moveBtn];
    self.moveBtn = moveBtn;
    self.lastTouchPoint = btn.touchPoint;
    // 移动按钮动画移动到手指的触碰点
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.moveBtn.transform = CGAffineTransformMakeTranslation(center.x - self.moveBtn.center.x, center.y - self.moveBtn.center.y);
    } completion:^(BOOL finished) {
        
    }];
    // 隐藏tabBarButton
    btn.hidden = YES;
}

/**
 *  调整拖拽tabBarButton的transForm  实现拖拽效果
 *
 *  @param lp 手势
 *
 *  @return MoveBtn的中心点
 */
- (CGPoint)adjustMoveBtnTransform:(UILongPressGestureRecognizer *)lp
{
    CGPoint point = [lp locationInView:lp.view];
    self.moveBtn.transform = CGAffineTransformTranslate(self.moveBtn.transform, point.x - self.lastTouchPoint.x, point.y - self.lastTouchPoint.y);
    self.lastTouchPoint = point;
    
    // 获取蒙板中心点
    CGPoint center = CGPointMake(self.moveBtn.frame.origin.x + self.moveBtn.frame.size.width * 0.5, self.moveBtn.frame.origin.y + self.moveBtn.frame.size.height * 0.5);
    return center;
}

/**
 *  调整自定义tabBarButton的transForm  实现换位效果
 *
 *  @param moveBtnCenter 拖拽tabBarButton的center
 */
- (void)adjustTabBarButtonTransform:(CGPoint)moveBtnCenter
{
    // 正在交换位置中就不需要再次交换了
    if (self.isChanging) return;
    // 当moveBtnCenter在其他的TabBarButton的区域时进行操作
    for (int i = 0; i < self.btns.count; i++) {
        // 取出tabBarButton
        MYTabBarButton *btn = self.btns[i];
        if (btn == self.selectedBtn) continue; // 选中的按钮排除在外
        // 获取tabBarButton在window中的frame
        CGRect btnFrame = [self convertRect:btn.frame toView:[UIApplication sharedApplication].keyWindow];
        // 当中间进入某个tabBarButton的区域时调整tabBarButton的位置,并且停止遍历
        if (CGRectContainsPoint(btnFrame, moveBtnCenter)) {
            self.destFrame = [self convertRect:btn.frame toView:[UIApplication sharedApplication].keyWindow];
            [self changeTabBarButtonPosition:btn];
            break;
        }
    }
}

- (void)changeTabBarButtonPosition:(MYTabBarButton *)btn
{
    // 已知选中按钮
    // 已知被选中区域的按钮
    // 两个按钮比较index
    // 如果选中按钮index小于区域按钮index  区域按钮左侧按钮全部左移
    // 如果选中按钮index大于区域按钮index  区域按钮右侧按钮全部右移
    self.changing = YES;
    NSUInteger currentIndex = self.selectedBtn.tag;
    NSUInteger index = btn.tag;
    NSInteger destTag = btn.tag;
    __block NSArray *moveBtns;
    if (currentIndex < index) {  // 集体左移
        [UIView animateWithDuration:kAnimationDuration animations:^{
            moveBtns = [self leftTabBarButtons:btn];
            [moveBtns enumerateObjectsUsingBlock:^(MYTabBarButton *btn, NSUInteger idx, BOOL *stop) {
                CGRect tempFrame = btn.frame;
                tempFrame.origin.x -= tempFrame.size.width;
                btn.frame = tempFrame;
            }];
        } completion:^(BOOL finished) {
            self.selectedBtn.tag = destTag;
            [moveBtns enumerateObjectsUsingBlock:^(MYTabBarButton *btn, NSUInteger idx, BOOL *stop) {
                btn.tag -= 1;
            }];
        }];
    } else {  // 集体右移
        [UIView animateWithDuration:kAnimationDuration animations:^{
            moveBtns = [self rightTabBarButtons:btn];
            [moveBtns enumerateObjectsUsingBlock:^(MYTabBarButton *btn, NSUInteger idx, BOOL *stop) {
                CGRect tempFrame = btn.frame;
                tempFrame.origin.x += tempFrame.size.width;
                btn.frame = tempFrame;
            }];
        } completion:^(BOOL finished) {
            self.selectedBtn.tag = destTag;
            [moveBtns enumerateObjectsUsingBlock:^(MYTabBarButton *btn, NSUInteger idx, BOOL *stop) {
                btn.tag += 1;
            }];
        }];
    }
}

/**
 *  左移时，获取所有要移动的按钮
 *
 *  @param btn 需要移动到的目标按钮
 *
 *  @return
 */
- (NSArray *)leftTabBarButtons:(MYTabBarButton *)btn
{
    NSMutableArray *moveBtns = [NSMutableArray array];
    [self.btns enumerateObjectsUsingBlock:^(MYTabBarButton *tabBarButton, NSUInteger idx, BOOL *stop) {
        if (tabBarButton.tag > self.selectedBtn.tag && tabBarButton.tag <= btn.tag) {
            [moveBtns addObject:tabBarButton];
        }
    }];
    return moveBtns;
}

/**
 *  右移时，获取所有要移动的按钮
 *
 *  @param btn 需要移动到的目标按钮
 *
 *  @return
 */
- (NSArray *)rightTabBarButtons:(MYTabBarButton *)btn
{
    NSMutableArray *moveBtns = [NSMutableArray array];
    [self.btns enumerateObjectsUsingBlock:^(MYTabBarButton *tabBarButton, NSUInteger idx, BOOL *stop) {
        if (tabBarButton.tag < self.selectedBtn.tag && tabBarButton.tag >= btn.tag) {
            [moveBtns addObject:tabBarButton];
        }
    }];
    return moveBtns;
}

/**
 *  自定义tabBarButton点击
 *
 *  @param btn 自定义tabBarButton
 */
- (void)btnClick:(UIButton *)btn
{
    // 获取角标
    NSUInteger index = [self.btns indexOfObject:btn];
    
    // 获取对应item
    UITabBarItem *item = self.items[index];
    
    // 切换控制器
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [self.delegate tabBar:self didSelectItem:item];
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.btns.count) return;
    CGFloat width = self.bounds.size.width / self.btns.count;
    CGFloat height = self.bounds.size.height;
    CGFloat y = 0;
    CGFloat x;
    for (int i = 0; i < self.btns.count; i++) {
        MYTabBarButton *btn = self.btns[i];
        x = i * width;
        CGRect frame = CGRectMake(x, y, width, height);
        [btn setFrame:frame];
    }
}

@end
