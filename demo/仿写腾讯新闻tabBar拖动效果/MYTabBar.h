//
//  MYTabBar.h
//  仿写腾讯新闻tabBar拖动效果
//
//  Created by 塔利班 on 15/6/12.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

/**
 结论:经过断点发现系统的tabBar实现流程如下
 1>设置完毕所有子控制器的tabBarItem
 2>调用tabBar的setItems animation 方法  在方法内根据item模型添加对应的tabBarButton
 3>tabBarButton点击后(tabBarController默认是tabBar的delegate 调用的是私有方法) 调用tabBarController的selectedIndex方法 改变当前显示的子控制器
 4>调用tabBar的setSelectedItem方法 改变当前选中的tabBarButton
 
 // 我们根据系统的流程  重写setItems animation 方法 添加自己的button
 // 通过delegate属性  调用公有api改变tabBarController当前显示的子控制器
 // 重写setSelectedItem方法  改变自己的button的选中状态
 
 // 优势:设置item依旧是系统的api
 */

#import <UIKit/UIKit.h>

@interface MYTabBar : UITabBar
/** tabBarButton图片上间距 */
@property (nonatomic, assign) CGFloat tabBarButtonImageViewTopMargin;
/** tabBarButton标题上间距 */
@property (nonatomic, assign) CGFloat tabBarButtonTitleLableTopMargin;

/** 设置titleText的属性 */
- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state;

/** 快速创建 */
+ (instancetype)tabBarWithTabBarButtonImageViewTopMargin:(CGFloat)tabBarButtonImageViewTopMargin tabBarButtonTitleLableTopMargin:(CGFloat)tabBarButtonTitleLableTopMargin;

@end
