//
//  BaseViewController.m
//  srollviewDemo
//
//  Created by sk on 2017/7/20.
//  Copyright © 2017年 szy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createHeaderView];
    
}

- (void)setHeaderView:(UIView *)headerView
{
    self.tableView.tableHeaderView = headerView;
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)createHeaderView
{
    // header rect 改成子类代理
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [self.delegate parentHeaderViewHeight])];
    headerView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.tableHeaderView = headerView;
}

- (void)dealloc {
    NSLog(@"%@销毁", self);
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(subScrollDidScroll:)])
    {
        [self.delegate subScrollDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.delegate respondsToSelector:@selector(subScrollDidEndDragging:willDecelerate:)])
    {
        [self.delegate subScrollDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(subScrollDidEndDecelerating:)])
    {
        [self.delegate subScrollDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(subScrollDidScrollToTop:)])
    {
        [self.delegate subScrollDidScrollToTop:scrollView];
    }
}

@end
