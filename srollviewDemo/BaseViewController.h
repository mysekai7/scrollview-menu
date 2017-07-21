//
//  BaseViewController.h
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SrollViewMenuConstant.h"

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

- (CGFloat)parentHeaderViewHeight;

@end

@interface BaseViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign) id <SubScrollDelegate> delegate;
//@property (nonatomic, strong) UIView *headerView;

@end
