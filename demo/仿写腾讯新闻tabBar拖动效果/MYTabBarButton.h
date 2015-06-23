//
//  MYTabBarButton.h
//  仿写腾讯新闻tabBar拖动效果
//
//  Created by 塔利班 on 15/6/12.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYTabBarButton : UIButton <NSCopying>
@property (nonatomic, assign) CGPoint touchPoint;
/** 图片上间距 */
@property (nonatomic, assign) CGFloat imageViewTopMargin;  // 默认是0
/** 标题上间距 */
@property (nonatomic, assign) CGFloat titleLabelTopMargin; // 默认是0
+ (instancetype)tabBarButtonWithImageViewTopMargin:(CGFloat)imageViewTopMargin titleLabelTopMargin:(CGFloat)titleLabelTopMargin;
/** 设置标题的属性字典 */
@end
