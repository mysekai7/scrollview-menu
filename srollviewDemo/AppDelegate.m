//
//  AppDelegate.m
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ScrollMenuConfigration.h"

#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //配置
    ScrollMenuConfigration *config = [ScrollMenuConfigration pageScrollViewMenuConfigration];
    config.showNavigation = NO;
    
    //子控制器
    NSArray *viewControllers = @[
                                    [OneViewController new],
                                    [TwoViewController new],
                                    [ThreeViewController new]
                                 ];
    
    //菜单标题
    NSArray *titles = @[@"one", @"two", @"three"];
    
    //主控制器初始化
    ViewController *vc = [ViewController pageScrollViewControllerWithControllers:viewControllers
                                                                          titles:titles
                                                                    Configration:config];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    view.backgroundColor = [UIColor blueColor];
    [view addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    vc.headView = view;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
