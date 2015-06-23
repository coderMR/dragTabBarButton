# dragTabBarButton
you can drag your tabBarButton

// creat our tabbar and replace the system tabbar
MYTabBar *tabBar = [MYTabBar tabBarWithTabBarButtonImageViewTopMargin:3 tabBarButtonTitleLableTopMargin:0];
[self setValue:tabBar forKeyPath:@"tabBar"];

// set tabbaritem image and title, if your item not have title, the UI effect look good
UINavigationController *nav0 = self.viewControllers.firstObject;
UINavigationController *nav1 = self.viewControllers.lastObject;
nav0.tabBarItem.image = [UIImage imageNamed:@"mine"];
nav0.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_selected"];
nav0.tabBarItem.title = @"关心";
nav1.tabBarItem.image = [UIImage imageNamed:@"news"];
nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"news_selected"];
nav1.tabBarItem.title = @"新闻";

// please copy this function in out tabBarController.m
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.selectedIndex = item.tag;
}

// OK! to enjoy it!  Please forgive my broken English! :)
