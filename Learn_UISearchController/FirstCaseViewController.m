//
//  FirstCaseViewController.m
//  Learn_UISearchController
//
//  Created by pzdf on 2018/7/10.
//  Copyright © 2018年 pzdf. All rights reserved.
//

#import "FirstCaseViewController.h"

@interface FirstCaseViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UISearchResultsUpdating,
UISearchBarDelegate,
UIScrollViewDelegate
>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchResult;

@end

@implementation FirstCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UISearchController 学习";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    // 如果不加 self.definesPresentationContext = YES; 侧滑返回或者点击搜索结果跳转详情页,搜索框不消失; iOS 11 isActive 状态下取消搜索,搜索框跳动;
    self.definesPresentationContext = YES;
    
    [self configData];
}

- (void)configData {
    for (int i = 0; i < 100; i++) {
        NSString *dataStr = [NSString stringWithFormat:@"第 %d 行", i];
        [self.dataList addObject:dataStr];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchController.isActive ? self.searchResult.count : self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    NSString *dataStr = self.searchController.isActive ? self.searchResult[indexPath.row] : self.dataList[indexPath.row];
    cell.textLabel.text = dataStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FirstCaseViewController *firstCaseVC = [[FirstCaseViewController alloc] init];
    [self.navigationController pushViewController:firstCaseVC animated:YES];
}

- (void)viewDidLayoutSubviews {
    if (self.searchController.active) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(StatusBarHeight);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.searchController.searchBar endEditing:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 禁用侧滑手势,防止 iOS 11 isActive 状态下侧滑一半,搜索框消失了
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchResult removeAllObjects];
    
    NSString *searchText = searchController.searchBar.text;
    if ([searchText isEqualToString:@""] || searchText.length == 0) {
        [self.tableView reloadData];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *dataStr in self.dataList) {
            if ([dataStr rangeOfString:searchText].location != NSNotFound) {
                [self.searchResult addObject:dataStr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - getters and setters

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"搜索文件";
        // 如果不加 [_searchController.searchBar sizeToFit], iOS 8 searchBar 显示空白
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.backgroundColor = [UIColor greenColor];
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;//关闭提示
        _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭自动首字母大写
    }
    return _searchController;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        CGFloat height = 44.0f;
        if (@available(iOS 11.0, *)) {
            height = 56.0f;
        }
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        [_tableHeaderView addSubview:self.searchController.searchBar];
    }
    return _tableHeaderView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)searchResult {
    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}

@end
