//
//  BaseViewController.h
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define headerViewHeight 200 // 头部图片刚开始显示的高度（实际高度并不是200）
#define navBarHeight 0  // 导航栏加状态栏高度
#define segmentBarHeight 40

@protocol SubScrollDelegate <NSObject>

@optional

/// 滚动ing
- (void)subScrollDidScroll:(UIScrollView *)scrollView;
/// 停止拖拽
- (void)subScrollDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/// 结束滚动
- (void)subScrollDidEndDecelerating:(UIScrollView *)scrollView;
/// 滚动到顶部
- (void)subScrollDidScrollToTop:(UIScrollView *)scrollView;

@end

@interface BaseViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign) id <SubScrollDelegate> delegate;
//@property (nonatomic, strong) UIView *headerView;

@end
