//
//  TabbarController.m
//  TestProject
//
//  Created by chensifang on 2018/9/17.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "TabbarController.h"
#import "UIController.h"
#import "DataController.h"
#import "ThreadController.h"
#import "AlgorithmController.h"
#import "LibController.h"
#import <ReactiveObjC.h>

@interface TabbarController () <UITabBarControllerDelegate>

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    NSArray *vcs = @[
                     @"UIController",
                     @"DataController",
                     @"ThreadController",
                     @"LibController",
                     @"MainAlgorithmController"
                     ];
    
    NSArray<Class> *vc_class = @[
                          NSClassFromString(vcs[0]),
                          NSClassFromString(vcs[1]),
                          NSClassFromString(vcs[2]),
                          NSClassFromString(vcs[3]),
                          NSClassFromString(vcs[4]),
                          ];
    
    FactoryViewController *UIVC = [[vc_class[0] alloc] init];
    UIVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"界面" image:[UIImage imageNamed:@"icon_tabBar_home_normal"] selectedImage:[UIImage imageNamed:@"icon_tabBar_home_select"]];
    [self addChildViewController:UIVC];
    
    FactoryViewController *dataVC = [[vc_class[1] alloc] init];
    dataVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"OC结构" image:[UIImage imageNamed:@"icon_tabBar_trend_normal"] selectedImage:[UIImage imageNamed:@"icon_tabBar_trend_select"]];
    [self addChildViewController:dataVC];
    
    FactoryViewController *threadVC = [[vc_class[2] alloc] init];
    threadVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"多线程" image:[UIImage imageNamed:@"icon_tabBar_celiang_normal"] selectedImage:[UIImage imageNamed:@"icon_tabBar_celiang_select"]];
    [self addChildViewController:threadVC];
    
    FactoryViewController *libVC = [[vc_class[3] alloc] init];
    libVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"三方库" image:[UIImage imageNamed:@"icon_tabBar_discover_normal"] selectedImage:[UIImage imageNamed:@"icon_tabBar_discover_select"]];
    [self addChildViewController:libVC];
    
    FactoryViewController *algorithmVC = [[vc_class[4] alloc] init];
    algorithmVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"算法" image:[UIImage imageNamed:@"icon_tabBar_mine_normal"] selectedImage:[UIImage imageNamed:@"icon_tabBar_mine_select"]];
    [self addChildViewController:algorithmVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"] unsignedIntegerValue];
}

#pragma mark - ---- UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.selectedIndex) forKey:@"selectIndex"];
}

@end
