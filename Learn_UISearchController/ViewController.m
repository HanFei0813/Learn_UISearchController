//
//  ViewController.m
//  Learn_UISearchController
//
//  Created by pzdf on 2018/7/10.
//  Copyright © 2018年 pzdf. All rights reserved.
//

#import "ViewController.h"
#import "CaseModel.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configView];
    [self configData];
    NSLog(@"");
}

- (void)configView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)configData {
    CaseModel *firstCase = [CaseModel new];
    firstCase.className = @"FirstCaseViewController";
    firstCase.desc = @"UISearchController 学习";
    [self.dataList addObject:firstCase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CaseModel *caseModel = self.dataList[indexPath.row];
    cell.textLabel.text = caseModel.desc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CaseModel *caseModel = self.dataList[indexPath.row];
    if (caseModel.className.length <= 0) {
        return;
    }
    UIViewController *caseVC = [[NSClassFromString(caseModel.className) class] new];
    [self.navigationController pushViewController:caseVC animated:YES];
}

#pragma mark - getters and setters

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
