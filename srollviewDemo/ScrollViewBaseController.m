//
//  ScrollViewBaseController.m
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import "ScrollViewBaseController.h"
#import "BaseViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>

#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

@interface ScrollViewBaseController () <UIScrollViewDelegate, SubScrollDelegate>



@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, assign) NSInteger currentIndex; // 当前页面索引

@property (nonatomic, strong) HMSegmentedControl *segCtrl;

@property (nonatomic, strong) BaseViewController *currentController; // 当前控制器

@property (nonatomic, assign) CGFloat distanceY; // 多个页面同步偏移量

@end

@implementation ScrollViewBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createMainScrollView];
    
    [self addController];
    
    [self createHeaderView];

    
    self.segCtrl.sectionTitles = @[@"one", @"two", @"three"];

    [self segmentedControlChangedValue:self.segCtrl];
}

- (void)createHeaderView
{
    //头部视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerViewHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.alpha = 0.4;
    
    //菜单
    _segCtrl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, headerViewHeight - segmentBarHeight, kScreenWidth, segmentBarHeight)];
    _segCtrl.backgroundColor = [UIColor redColor];
    _segCtrl.selectedSegmentIndex = 0;
    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [_headerView addSubview:_segCtrl];
    
    [self.view addSubview:_headerView];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {

    NSInteger toIndex = sender.selectedSegmentIndex;
    
    // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - _currentIndex) >= 2) {
        // 如果动画为NO,则会立即调用scrollViewDidScroll，scrollViewDidScroll中做了一个很重要的操作：改变每个tableView的头视图的frame，如果先调scrollViewDidScroll,然后继续来到此方法走完剩余代码，走到targetViewController.headerView = self.headerView这一行时，内部把头视图的origin都归0了，所以有时会导致头视图的origin为(0,0)的情况，为了避免这个问题，有一种办法是设置动画为YES，如果有动画，则会把本方法先走完，再去调scrollViewDidScroll,这便不会导致头视图origin为0的情况，但是这里用动画不太好看，所以固定在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scrollview setContentOffset:CGPointMake(self.scrollview.frame.size.width * toIndex, 0) animated:NO];
        });
    } else {
        [self.scrollview setContentOffset:CGPointMake(self.scrollview.frame.size.width * toIndex, 0) animated:YES];
    }
    
    [self showChildVCViewsAtIndex:toIndex];
}

- (void)addController
{
    OneViewController *oneVC = [[OneViewController alloc] init];
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    ThreeViewController *threeVC = [[ThreeViewController alloc] init];
    
    [self addChildViewController:oneVC];
    [self addChildViewController:twoVC];
    [self addChildViewController:threeVC];
    
}

- (void)createMainScrollView
{
    _scrollview = [[UIScrollView alloc]init];
    _scrollview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _scrollview.backgroundColor = [UIColor whiteColor];
    _scrollview.scrollEnabled = YES;
    _scrollview.contentOffset = CGPointMake(0, 0);
    _scrollview.delegate = self;
    _scrollview.pagingEnabled = YES;
    _scrollview.bounces = YES;
    //_scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
    [self.view addSubview:_scrollview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == self.scrollview) {
        
        
        // 将当前控制器的view带到最前面去，这是为了防止下一个控制器的view挡住了头部
//        BaseViewController *targetVC = self.childViewControllers[_currentIndex];
//        if ([targetVC isViewLoaded]) {
//            //[self.scrollview bringSubviewToFront:targetVC.view];
//        }
        
    }
}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollview) {
        
    }
}

//滑动切换页面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollview) {
        
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self.segCtrl setSelectedSegmentIndex:index animated:YES];

        _currentIndex = index;
        
        [self showChildVCViewsAtIndex:index];
    }
}

//显示指定页面
- (void)showChildVCViewsAtIndex:(NSInteger)toIndex
{
    self.currentController.delegate = nil;
    
    BaseViewController *targetVC = self.childViewControllers[toIndex];
    targetVC.delegate = self;
    self.currentController = targetVC;
    
    if ([targetVC isViewLoaded]) {
        return;
    }
    
    targetVC.view.frame = CGRectMake(self.view.frame.size.width * toIndex, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    
    [self.scrollview addSubview:targetVC.view];
    
    if (self.distanceY>0) {
        CGPoint contentOffSet = targetVC.tableView.contentOffset;
        contentOffSet.y = self.distanceY;
        targetVC.tableView.contentOffset = contentOffSet;
    }
}

#pragma mark ChildControllerScrollDelegate

/// 滚动ing
- (void)subScrollDidScroll:(UIScrollView *)scrollView
{
    if (!self.currentController.isViewLoaded) {
        return;
    }
    
    //拖拽偏移量，负数↓ 正数↑
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY: %lf", offsetY);
    
    if (offsetY >= headerViewHeight - navBarHeight - segmentBarHeight) { //到达导航栏底部
        //固定
        NSLog(@"fix菜单");
        
        CGRect rect = self.headerView.frame;
        rect.origin.y = -(headerViewHeight - navBarHeight - segmentBarHeight);
        self.headerView.frame = rect;
    } else {
        //随滑动移动菜单
        NSLog(@"move菜单");
        
        CGRect rect = self.headerView.frame;
        rect.origin.y = -offsetY;
        self.headerView.frame = rect;
    }

    [self followScrollingScrollView:scrollView distanceY:offsetY];
}
/// 停止拖拽
- (void)subScrollDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}
/// 结束滚动
- (void)subScrollDidEndDecelerating:(UIScrollView *)scrollView
{

}
/// 滚动到顶部
- (void)subScrollDidScrollToTop:(UIScrollView *)scrollView
{
    
}

// 所有子控制器上的特定scrollView同时联动
- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    
    if (distanceY > headerViewHeight - navBarHeight - segmentBarHeight) {
        _distanceY = headerViewHeight - navBarHeight - segmentBarHeight;
        return;
    }
    _distanceY = distanceY;
    
    BaseViewController *baseVc = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        baseVc = self.childViewControllers[i];
        if (baseVc == self.currentController) {
            continue;
        }
        // 除去当前正在滑动的 scrollView之外，其余scrollView的改变量等于悬浮菜单的改变量
        CGPoint contentOffSet = baseVc.tableView.contentOffset;
        NSLog(@"OFFSET: %@, distanceY:%lf", NSStringFromCGPoint(contentOffSet), distanceY);
        contentOffSet.y = distanceY;
        baseVc.tableView.contentOffset = contentOffSet;
    }
}
@end
