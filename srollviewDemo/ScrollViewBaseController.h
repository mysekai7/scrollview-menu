//
//  ScrollViewBaseController.h
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SrollViewMenuConstant.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "ScrollMenuConfigration.h"
#import "BaseViewController.h"


@interface ScrollViewBaseController : UIViewController

/** 控制器*/
@property (nonatomic, strong) NSMutableArray *viewControllers;
/** 菜单Menu标题*/
@property (nonatomic, strong) NSMutableArray *titleArrayM;
/** 当前控制器*/
@property (nonatomic, strong) BaseViewController *currentController;
/** 当前页面索引*/
@property (nonatomic, assign, readonly) NSInteger currentIndex;
/** 悬浮样式 作为UITableHeaderView*/
@property (nonatomic, strong) UIView *headView;
/** 菜单*/
@property (nonatomic, strong) HMSegmentedControl *segCtrl;
/** 容器 */
@property (nonatomic, strong) UIScrollView *scrollview;
/** 配置信息*/
@property (nonatomic, strong) ScrollMenuConfigration *configration;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

/**
 *  初始化控制器
 *
 *  @param viewControllers 控制器数组
 *  @param titleArrayM     菜单title数组
 *  @param configration    配置信息
 *
 */
+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(ScrollMenuConfigration *)configration;
- (instancetype)initWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(ScrollMenuConfigration *)configration;

@end
