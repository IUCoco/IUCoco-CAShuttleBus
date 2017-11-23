//
//  CASShuttleBusRouteViewController.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/21.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASShuttleBusRouteViewController.h"
#import "CASShuttleBusRouteCell.h"
#import "CASShuttleBusRouteItem.h"

#define Y1               50

@interface CASShuttleBusRouteViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *shuttleBusRouteArrM;

@end

@implementation CASShuttleBusRouteViewController

static NSString * const CASShuttleBusRouteCellID = @"CASShuttleBusRouteCellID";

#pragma mark - lazyload

- (UITableView *)myTab {
    if (!_myTab) {
        CGRect tabFrame = CGRectMake(0, 0, CASScreenWith, CASScreenHight - 50);
        UITableView *myTab = [[UITableView alloc] initWithFrame:tabFrame style:UITableViewStylePlain];
        myTab.backgroundColor = [UIColor lightGrayColor];
        myTab.showsVerticalScrollIndicator = NO;
        myTab.showsHorizontalScrollIndicator = NO;
        myTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        //不让tab在边缘有弹簧效果
        myTab.bounces = NO;
        //让tab默认禁止滚动
        myTab.scrollEnabled = NO;
        myTab.delegate = self;
        myTab.dataSource = self;
        _myTab = myTab;
    }
    return _myTab;
}

-(UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.frame = CGRectMake(0, 0, CASScreenWith, 50);
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.barTintColor = [UIColor whiteColor];
        // 去掉searchBar上下的两条黑线
        [_searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"searchBar_normal_bg"]];
        [_searchController.searchBar sizeToFit];
        // 设置开始搜索时背景显示与否
        _searchController.dimsBackgroundDuringPresentation = NO; // 就是那一块黑色像蒙版一样的
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (NSMutableArray *)shuttleBusRouteArrM {
    if (!_shuttleBusRouteArrM) {
#warning 暂时没有数据源 利用plist代替
        _shuttleBusRouteArrM = [CASShuttleBusRouteItem mj_objectArrayWithFilename:@"CASShuttleBusRouteItem.plist"];
    }
    return _shuttleBusRouteArrM;
}

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    //必须添加，否则点击搜索框向上移
    self.definesPresentationContext = YES;
    [self setupSubViews];
    [self.myTab registerClass:[CASShuttleBusRouteCell class] forCellReuseIdentifier:CASShuttleBusRouteCellID];
}

/**
 * 功能：禁止横屏
 */

- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - setupUI
- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 10;
    [self.view addSubview:self.myTab];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 删除text时收键盘
    if (searchText.length == 0) {
        UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
        // 代码触发Button的点击事件
        [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 清空textfield
//    searchBar.text = @"";
    CASLog(@"%zd", __func__);
}

/**
 每次点击searchBar的textField时，都会走这个方法
 
 *      返回false时， searchBar的textField点击没有反应
 *      默认返回true
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (!self.offsetY) {
        self.offsetY = Y1;
    }
    
    // 如果点击时，shadowView的y坐标 在Y2 Y3的位置，
    if (self.offsetY > Y1) {
        // ============ 触发block =============
        if (self.didClickTextFieldBlock) {
            self.didClickTextFieldBlock();
        }
        return false;
    }
    return true;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.shuttleBusRouteArrM.count;
    return self.shuttleBusRouteArrM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CASShuttleBusRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CASShuttleBusRouteCellID];
    cell.item = self.shuttleBusRouteArrM[indexPath.row];
    //处理cell上面button点击
    cell.lineDepartureBtnClick = ^(UIButton *btn) {
        [self lineDepartureButtonClick:btn];
        CASLog(@"%ld++++++++++", indexPath.row);
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   return [self setUpCellHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TopBar_Height + NavigationBar_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // searchBar收起键盘
    UIButton *cancelBtn = [self.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    //    UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"];
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    //    NSLog(@"+++++++ didSelect ++++++++");
#warning 跳转至具体班车路线页面
}


#pragma mark - 私有方法
- (UIView *)setUpCellHeaderView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CASScreenWith, TopBar_Height + NavigationBar_HEIGHT)];
    backgroundView.backgroundColor = [UIColor whiteColor];//蓝色
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, CASScreenWith, NavigationBar_HEIGHT)];
    [searchView addSubview:self.searchController.searchBar];//50
    [backgroundView addSubview:searchView];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake((CASScreenWith-40)/2.0, -2, 40, 28);
    image.image = [UIImage imageNamed:@"Indicator_line"];
    [backgroundView addSubview:image];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, CASScreenWith, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [backgroundView addSubview:lineView];
    
    return backgroundView;

}

-(void)didClickTextField:(DidClickTextFieldBlock)block
{
    self.didClickTextFieldBlock = block;
}

- (void)lineDepartureButtonClick:(UIButton *)btn {
    
}

@end
