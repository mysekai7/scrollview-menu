//
//  ScrollViewBaseController.m
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import "ScrollViewBaseController.h"

@interface ScrollViewBaseController () <UIScrollViewDelegate, SubScrollDelegate>

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign, readwrite) NSInteger currentIndex; // 当前页面索引

@property (nonatomic, assign) CGFloat distanceY; // 多个页面同步偏移量

@property (nonatomic, assign) BOOL lockDidScrollView;

//headerViewHeight
@property (nonatomic, assign) CGFloat headerViewHeight;

@end

@implementation ScrollViewBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.hidden = !self.configration.showNavigation;
    
    self.lockDidScrollView = YES;
    
    [self checkParams]; //检查参数

    [self createMainScrollView]; //主scrollview
    
    [self addController]; //控制器
    
    [self createHeaderView]; //头部视图
    
    [self createNavView]; //导航

    [self segmentedControlChangedValue:self.segCtrl]; //初始化菜单
}

- (void)checkParams{
    
    NSAssert(self.viewControllers.count != 0 || self.viewControllers, @"ViewControllers`count is 0 or nil");
    NSAssert(self.titleArrayM.count != 0 || self.titleArrayM, @"titleArray`count is 0 or nil,");
    NSAssert(self.viewControllers.count == self.titleArrayM.count, @"ViewControllers`count is  not equal titleArray!");
    
    BOOL isHasNotEqualTitle = YES;
    for (int i = 0; i < self.titleArrayM.count; i++) {
        for (int j = 1; j < self.titleArrayM.count; j++) {
            
            if (i != j && [self.titleArrayM[i] isEqualToString:self.titleArrayM[j]]) {
                isHasNotEqualTitle = NO;
                break;
            }
        }
    }
    NSAssert(isHasNotEqualTitle, @"titleArray Not allow equal title.");
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.lockDidScrollView = NO;
}

- (void)createNavView
{
    CGFloat deltaHeight = !self.configration.showNavigation ? navBarHeight : 0;
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, deltaHeight)];
    navView.backgroundColor = [UIColor redColor];
    navView.hidden = self.configration.showNavigation;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, 20)];
    titleLabel.text = @"李小南";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:titleLabel];
    
    navView.alpha = 0;
    [self.view addSubview:navView];
    self.navView = navView;
}

- (void)createHeaderView
{
    //头部视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, segmentBarHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat headViewHeight = 0;
    if (self.headView) {
        headViewHeight = self.headView.frame.size.height;
        [_headerView addSubview:self.headView];
    }
    
    //菜单
    _segCtrl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, headViewHeight, kScreenWidth, segmentBarHeight)];
    _segCtrl.backgroundColor = [UIColor redColor];
    _segCtrl.selectedSegmentIndex = 0;
    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    _segCtrl.sectionTitles = self.titleArrayM;
    [_headerView addSubview:_segCtrl];
    [self.view addSubview:_headerView];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, headViewHeight + segmentBarHeight);
    
    self.headerViewHeight = self.headerView.frame.size.height;
}

- (void)setupNavBarWithOffsetY:(CGFloat)offsetY
{
    CGFloat alpha = 0;
    CGFloat originalOffsetY = 0;
    
    CGFloat deltaHeight = !self.configration.showNavigation ? navBarHeight : 0;
    
    if (offsetY < originalOffsetY) {
        alpha = 0;
    } else if(offsetY <= (self.headerViewHeight - deltaHeight - segmentBarHeight) && offsetY >= originalOffsetY) {
        alpha = offsetY / (self.headerViewHeight - deltaHeight - segmentBarHeight);
    } else { // 标题栏固定在顶部时
        alpha = 1;
    }
    
    self.navView.alpha = alpha;
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
    for (int i=0; i<self.viewControllers.count; i++) {
        [self addChildViewController:[self.viewControllers objectAtIndex:i]];
    }
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
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
    [self.view addSubview:_scrollview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (self.lockDidScrollView) return;
    
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
    
    CGFloat deltaHeight =  !self.configration.showNavigation ? navBarHeight : 0;
    
    if (offsetY >= self.headerViewHeight - deltaHeight - segmentBarHeight) { //到达导航栏底部
        //固定
        NSLog(@"fix菜单");
        
        CGRect rect = self.headerView.frame;
        rect.origin.y = -(self.headerViewHeight - deltaHeight - segmentBarHeight);
        self.headerView.frame = rect;
    } else {
        //随滑动移动菜单
        NSLog(@"move菜单");
        
        CGRect rect = self.headerView.frame;
        rect.origin.y = -offsetY;
        self.headerView.frame = rect;
    }

    [self setupNavBarWithOffsetY:offsetY];
    
    [self followScrollingScrollView:scrollView distanceY:offsetY];
}
/// 停止拖拽
- (void)subScrollDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}
/// 结束滚动
- (void)subScrollDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    [self setupNavBarWithOffsetY:offsetY];
}
/// 滚动到顶部
- (void)subScrollDidScrollToTop:(UIScrollView *)scrollView
{
    
}

// 所有子控制器上的特定scrollView同时联动
- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    
    CGFloat deltaHeight =  !self.configration.showNavigation ? navBarHeight : 0;
    
    if (distanceY > self.headerViewHeight - deltaHeight - segmentBarHeight) {
        _distanceY = self.headerViewHeight - deltaHeight - segmentBarHeight;
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

- (CGFloat)parentHeaderViewHeight
{
    return self.headerViewHeight;
}

#pragma mark - Public Mehtod

+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(ScrollMenuConfigration *)configration{
    
    ScrollViewBaseController *viewController =  [[self alloc] initWithControllers:viewControllers titles:titleArrayM Configration:configration];
    
    return viewController;
}

- (instancetype)initWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(ScrollMenuConfigration *)configration {
    if (self = [super init]) {
        self.viewControllers = viewControllers.mutableCopy;
        self.titleArrayM = titleArrayM.mutableCopy;
        self.configration = configration ? configration : [ScrollMenuConfigration pageScrollViewMenuConfigration];
    }
    return self;
}

@end
