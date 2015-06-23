//
//  MYTabBarButton.m
//  仿写腾讯新闻tabBar拖动效果
//
//  Created by 塔利班 on 15/6/12.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

// 无文本  图片的布局

// 有文本  文本与图片的布局  暴露接口  让开发者自己调整 满足项目需求

// 文本的字体...属性        如何利用系统的api做到


#import "MYTabBarButton.h"

NSString *const fontAttributeName = @"fontAttributeName";

@implementation MYTabBarButton

//#pragma mark - LazyLoad

//- (NSMutableDictionary *)titleAttributes
//{
//    if (_titleAttributes == nil) {
//        _titleAttributes = [NSMutableDictionary dictionary];
//        _titleAttributes[fontAttributeName] = [UIFont systemFontOfSize:13];
//        _titleAttributes
//    }
//    return nil;
//}

#pragma mark - Public Interface Mehtod

+ (instancetype)tabBarButtonWithImageViewTopMargin:(CGFloat)imageViewTopMargin titleLabelTopMargin:(CGFloat)titleLabelTopMargin
{
    MYTabBarButton *tabBarButton = [[self alloc] init];
    tabBarButton.imageViewTopMargin = imageViewTopMargin;
    tabBarButton.titleLabelTopMargin = titleLabelTopMargin;
    return tabBarButton;
}

#pragma mark - LifeCircle Method

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

#pragma mark - System Method

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    self.touchPoint = point;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 有文本
    if (self.titleLabel.text.length) {
        self.imageView.frame = CGRectMake((self.bounds.size.width - self.currentImage.size.width) * 0.5, self.imageViewTopMargin, self.currentImage.size.width, self.currentImage.size.height);
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + self.titleLabelTopMargin, self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.imageView.frame) + 3);
    }
}

@end
