//
//  MYTabBarController.m
//  仿写腾讯新闻tabBar拖动效果
//
//  Created by 塔利班 on 15/6/12.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#import "MYTabBarController.h"
#import "MYTabBar.h"

@interface MYTabBarController ()

@end

@implementation MYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义tabBar
    MYTabBar *tabBar = [MYTabBar tabBarWithTabBarButtonImageViewTopMargin:3 tabBarButtonTitleLableTopMargin:0];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    // 设置tabBarItem  image+title
    UINavigationController *nav0 = self.viewControllers.firstObject;
    UINavigationController *nav1 = self.viewControllers.lastObject;
    nav0.tabBarItem.image = [UIImage imageNamed:@"mine"];
    nav0.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_selected"];
    nav0.tabBarItem.title = @"关心";
    nav1.tabBarItem.image = [UIImage imageNamed:@"news"];
    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"news_selected"];
    nav1.tabBarItem.title = @"新闻";
    
    // title的属性字典
    NSMutableDictionary *norAttrs = [NSMutableDictionary dictionary];
    norAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    norAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [tabBar setTitleTextAttributes:norAttrs forState:UIControlStateNormal];
    NSMutableDictionary *selAttrs = [NSMutableDictionary dictionaryWithDictionary:norAttrs];
    selAttrs[NSForegroundColorAttributeName] = [UIColor purpleColor];
    [tabBar setTitleTextAttributes:selAttrs forState:UIControlStateSelected];
}

#pragma mark - UITabBarDelegate

/**
 *  系统的tabBar的delegate默认就是tabBarVc  这是选中了某个tabBarButton的回调
 *  但是我们没有用系统的tabBarButton  而是自定义的tabBarButton  因此我们在自定义的tabBarButton点击时调用代理的这个方法
 *
 *  @param tabBar 你麻痹,你说这是啥,你们城里人真会玩
 *  @param item   选中的tabBarButton的item模型
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.selectedIndex = item.tag;  // 这句代码会调用到系统的setSelectedItem方法  系统默认在这个方法中改变tabBarButton的状态  但是我们是自定义tabBarButton  只能手动实现
}

@end
